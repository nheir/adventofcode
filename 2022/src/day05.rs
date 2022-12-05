// I'm definitely doing things wrong here

use std::str::FromStr;

type Stack = Vec<u8>;
type Stacks = Vec<Stack>;
pub struct Instruction {
    count: usize,
    from: usize,
    to: usize,
}
type Instructions = Vec<Instruction>;

impl FromStr for Instruction {
    type Err = u8;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut sl = s
            .split_whitespace()
            .filter(|s| s.chars().all(|c| c.is_numeric()));
        Ok(Instruction {
            count: sl.next().unwrap().parse::<usize>().unwrap(),
            from: sl.next().unwrap().parse::<usize>().unwrap() - 1,
            to: sl.next().unwrap().parse::<usize>().unwrap() - 1,
        })
    }
}

impl Instruction {
    fn move9000(&self, ss: &mut Stacks) {
        for _ in 0..self.count {
            let head = ss[self.from].pop().unwrap();
            ss[self.to].push(head)
        }
    }
    fn move9001(&self, ss: &mut Stacks) {
        let p = ss[self.from].len() - self.count;
        for i in 0..self.count {
            let v = ss[self.from][p + i];
            ss[self.to].push(v);
        }
        ss[self.from].truncate(p);
    }
}

#[aoc_generator(day5)]
pub fn input_generator(input: &str) -> (Stacks, Instructions) {
    let (ss, ii) = input.split_once("\n\n").unwrap();
    let n = ss.lines().last().unwrap().len() / 4 + 1;
    let mut stacks: Stacks = (0..n).map(|_| vec![]).collect();

    for l in ss.lines().rev().skip(1) {
        for (i, c) in l.bytes().skip(1).step_by(4).enumerate() {
            if c != b' ' {
                stacks[i].push(c);
            }
        }
    }

    let mv: Instructions = ii
        .lines()
        .map(|l| l.parse::<Instruction>().unwrap())
        .collect();
    (stacks, mv)
}

#[aoc(day5, part1)]
pub fn part1((ss, is): &(Stacks, Instructions)) -> String {
    let mut a = ss.clone();
    for inst in is {
        inst.move9000(&mut a);
    }
    String::from_utf8(a.iter().map(|v| *v.last().unwrap()).collect()).unwrap()
}

#[aoc(day5, part2)]
pub fn part2((ss, is): &(Stacks, Instructions)) -> String {
    let mut a = ss.clone();
    for inst in is {
        inst.move9001(&mut a);
    }
    String::from_utf8(a.iter().map(|v| *v.last().unwrap()).collect()).unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(&input_generator(EXAMPLE)), "CMZ");
    }

    #[test]
    fn part2_examples() {
        assert_eq!(part2(&input_generator(EXAMPLE)), "MCD");
    }
}
