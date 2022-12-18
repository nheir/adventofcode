#[aoc_generator(day18)]
pub fn input_generator(input: &str) -> Vec<(usize, usize, usize)> {
    input
        .lines()
        .map(|l| {
            let v: Vec<_> = l.split(",").take(3).map(|s| s.parse().unwrap()).collect();
            (v[0], v[1], v[2])
        })
        .collect()
}

#[aoc(day18, part1)]
pub fn part1(input: &[(usize, usize, usize)]) -> u32 {
    let mut cub = Box::new([[[0 as u8; 23]; 23]; 23]);
    let mut count = 0;
    for &(a, b, c) in input {
        cub[a][b][c] = 1;
        for (i, j, k) in [(0, 0, 1), (0, 1, 0), (1, 0, 0)] {
            if cub[a + i][b + j][c + k] == 0 {
                count += 1
            } else {
                count -= 1
            }
            if cub[a - i][b - j][c - k] == 0 {
                count += 1
            } else {
                count -= 1
            }
        }
    }
    count
}

pub fn flood(cub: &mut Box<[[[u8; 23]; 23]; 23]>, a: usize, b: usize, c: usize) -> usize {
    if cub[a][b][c] == 0 {
        cub[a][b][c] = 2;
        let mut sum = 0;
        for (i, j, k) in [(0, 0, 1), (0, 1, 0), (1, 0, 0)] {
            if a + i < 23 && b + j < 23 && c + k < 23 {
                sum += flood(cub, a + i, b + j, c + k);
            }
            if a > i && b > j && c > k {
                sum += flood(cub, a - i, b - j, c - k);
            }
        }
        sum
    } else if cub[a][b][c] == 1 {
        1
    } else {
        0
    }
}

#[aoc(day18, part2)]
pub fn part2(input: &[(usize, usize, usize)]) -> usize {
    let mut cub: Box<[[[u8; 23]; 23]; 23]> = Box::new([[[0 as u8; 23]; 23]; 23]);
    for &(a, b, c) in input {
        cub[a][b][c] = 1;
    }
    let mut count = 0;
    let mut stack = vec![];
    stack.push((0, 0, 0));
    while let Some((a, b, c)) = stack.pop() {
        if cub[a][b][c] == 0 {
            cub[a][b][c] = 2;
            for (i, j, k) in [(0, 0, 1), (0, 1, 0), (1, 0, 0)] {
                if a + i < 23 && b + j < 23 && c + k < 23 {
                    let key = (a + i, b + j, c + k);
                    stack.push(key);
                }
                if a > i && b > j && c > k {
                    let key = (a - i, b - j, c - k);
                    stack.push(key);
                }
            }
        } else if cub[a][b][c] == 1 {
            count += 1;
        }
    }
    count
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(&input_generator(EXAMPLE)), 64);
    }
    #[test]
    fn part2_examples() {
        assert_eq!(part2(&input_generator(EXAMPLE)), 58);
    }
}
