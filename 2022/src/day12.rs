use std::collections::HashSet;

type Coord = (usize, usize);

fn go(grid: &Vec<Vec<u8>>, (a, b): Coord, (c, d): Coord) -> bool {
    let s = match grid[a][b] {
        b'S' => b'a',
        b'E' => b'z',
        v => v,
    };
    let e = match grid[c][d] {
        b'S' => b'a',
        b'E' => b'z',
        v => v,
    };
    e < 2 + s
}

fn find(grid: &Vec<Vec<u8>>, start: Coord, target: u8) -> usize {
    let mut count: usize = 0;
    let mut discover: Vec<Coord> = Vec::new();
    let mut seen: HashSet<Coord> = HashSet::new();
    let w = grid.len();
    let h = grid[0].len();
    discover.push(start);
    'main: while discover.len() > 0 {
        count += 1;
        let mut next_discover: Vec<Coord> = Vec::new();
        while let Some((i, j)) = discover.pop() {
            if seen.contains(&(i, j)) {
                continue;
            }
            seen.insert((i, j));

            if grid[i][j] == target {
                break 'main;
            }

            if i > 0 && go(&grid, (i - 1, j), (i, j)) {
                next_discover.push((i - 1, j));
            }
            if j > 0 && go(&grid, (i, j - 1), (i, j)) {
                next_discover.push((i, j - 1));
            }
            if i < w - 1 && go(&grid, (i + 1, j), (i, j)) {
                next_discover.push((i + 1, j));
            }
            if j < h - 1 && go(&grid, (i, j + 1), (i, j)) {
                next_discover.push((i, j + 1));
            }
        }
        discover = next_discover;
    }
    count - 1
}

#[aoc(day12, part1, Bytes)]
pub fn part1(input: &[u8]) -> usize {
    let grid: Vec<Vec<u8>> = input.split(|&c| c == b'\n').map(|l| l.to_vec()).collect();
    let w = grid.len();
    let h = grid[0].len();
    for i in 0..w {
        for j in 0..h {
            if grid[i][j] == b'E' {
                return find(&grid, (i, j), b'S');
            }
        }
    }
    0
}

#[aoc(day12, part2, Bytes)]
pub fn part2(input: &[u8]) -> usize {
    let grid: Vec<Vec<u8>> = input.split(|&c| c == b'\n').map(|l| l.to_vec()).collect();
    let w = grid.len();
    let h = grid[0].len();
    for i in 0..w {
        for j in 0..h {
            if grid[i][j] == b'E' {
                return find(&grid, (i, j), b'a');
            }
        }
    }
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE1: &str = "Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&EXAMPLE1.as_bytes()), 31);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(&EXAMPLE1.as_bytes()), 29);
    }
}
