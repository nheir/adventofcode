fn find_key(input: &str, size: usize) -> usize {
    let v = input
        .bytes()
        .map(|c| (c - b'a') as usize)
        .collect::<Vec<usize>>();
    let mut map = [0; 26];
    let mut counter = 0;
    for &c in v.iter().take(size) {
        if map[c] == 0 {
            counter += 1;
        }
        map[c] += 1;
    }
    for (i, &c) in v.iter().skip(size).enumerate() {
        if counter == size {
            return i + size;
        }
        if map[c] == 0 {
            counter += 1;
        }
        map[c] += 1;
        map[v[i]] -= 1;
        if map[v[i]] == 0 {
            counter -= 1;
        }
    }
    input.len()
}

#[aoc(day6, part1)]
pub fn part1(input: &str) -> usize {
    find_key(input, 4)
}

#[aoc(day6, part2)]
pub fn part2(input: &str) -> usize {
    find_key(input, 14)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part1_examples() {
        assert_eq!(part1("bvwbjplbgvbhsrlpgdmjqwftvncz"), 5);
        assert_eq!(part1("nppdvjthqldpwncqszvftbrmjlhg"), 6);
        assert_eq!(part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), 10);
        assert_eq!(part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), 11);
    }

    #[test]
    fn part2_examples() {
        assert_eq!(part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb"), 19);
        assert_eq!(part2("bvwbjplbgvbhsrlpgdmjqwftvncz"), 23);
        assert_eq!(part2("nppdvjthqldpwncqszvftbrmjlhg"), 23);
        assert_eq!(part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), 29);
        assert_eq!(part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), 26);
    }
}
