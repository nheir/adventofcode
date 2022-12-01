#[aoc(day1, part1)]
pub fn part1_chars(input: &str) -> u32 {
    let mut sum: u32 = 0;
    let mut ret: u32 = 0;

    for s in input.lines() {
        match s {
            "" => {
                ret = if sum < ret { ret } else { sum };
                sum = 0
            }
            _ => sum += s.parse::<u32>().unwrap(),
        }
    }
    if sum < ret {
        ret
    } else {
        sum
    }
}

#[aoc(day1, part2)]
pub fn part2_chars(input: &str) -> u32 {
    let mut sum: u32 = 0;
    let mut vec: Vec<u32> = vec![0,0,0,0];

    for s in input.lines() {
        match s {
            "" => {
                vec[0] = sum;
                vec.sort();
                sum = 0
            }
            _ => sum += s.parse::<u32>().unwrap(),
        }
    }
    vec[1] + vec[2] + vec[3]
}
