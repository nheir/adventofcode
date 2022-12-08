#[aoc_generator(day8)]
pub fn input_generator(input: &str) -> Vec<Vec<u8>> {
    input.lines().map(|l| l.bytes().collect()).collect()
}

#[aoc(day8, part1)]
pub fn part1(input: &Vec<Vec<u8>>) -> usize {
    let h = input.len();
    let w = input.get(0).unwrap().len();
    let mut grid: Vec<Vec<u32>> = Vec::new();
    for _ in 0..h {
        grid.push(Vec::new());
        grid.last_mut().unwrap().resize(w, 0);
    }
    for j in 0..h {
        let mut max_left = 0;
        let mut max_right = 0;
        for i in 0..w {
            if input[j][i] > max_left {
                grid[j][i] += 1;
                max_left = input[j][i];
            }
            if max_right < input[j][w - i - 1] {
                grid[j][w - i - 1] += 1;
                max_right = input[j][w - i - 1];
            }
        }
    }
    for i in 0..w {
        let mut max_top = 0;
        let mut max_bottom = 0;
        for j in 0..h {
            if input[j][i] > max_top {
                grid[j][i] += 1;
                max_top = input[j][i];
            }
            if max_bottom < input[h - j - 1][i] {
                grid[h - j - 1][i] += 1;
                max_bottom = input[h - j - 1][i];
            }
        }
    }
    grid.iter()
        .map(|l| l.iter().filter(|v| **v > 0).count())
        .sum()
}

fn score(grid: &Vec<Vec<u8>>, w: usize, h: usize, i: usize, j: usize) -> u32 {
    let mut a = 0;
    let v = grid[j][i];
    for x in i + 1..w {
        a += 1;
        if grid[j][x] >= v {
            break;
        }
    }
    let mut b = 0;
    for x in 0..i {
        b += 1;
        if grid[j][i - x - 1] >= v {
            break;
        }
    }
    let mut c = 0;
    for y in j + 1..h {
        c += 1;
        if grid[y][i] >= v {
            break;
        }
    }
    let mut d = 0;
    for y in 0..j {
        d += 1;
        if grid[j - y - 1][i] >= v {
            break;
        }
    }
    a * b * c * d
}

#[aoc(day8, part2)]
pub fn part2(input: &Vec<Vec<u8>>) -> u32 {
    let h = input.len();
    let w = input.get(0).unwrap().len();
    let mut best = 0;
    for j in 1..h - 1 {
        for i in 1..w - 1 {
            let s = score(&input, w, h, i, j);
            if s > best {
                best = s;
            }
        }
    }
    best
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "30373
25512
65332
33549
35390";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(&input_generator(&EXAMPLE)), 21);
    }

    #[test]
    fn part2_examples() {
        assert_eq!(part2(&input_generator(&EXAMPLE)), 8);
    }
}
