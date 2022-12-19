use std::{
    collections::{HashMap, VecDeque},
    hash::Hash,
    str::FromStr,
    string::ParseError,
};

type Vec4 = [usize; 4];

#[derive(Debug)]
pub struct Blueprint {
    rules: [Vec4; 4],
}

fn s2n(s: &str) -> Option<usize> {
    match s {
        "ore" => Some(0),
        "clay" => Some(1),
        "obsidian" => Some(2),
        "geode" => Some(3),
        v => {
            if let Ok(v) = v.parse() {
                Some(v)
            } else {
                None
            }
        }
    }
}

impl FromStr for Blueprint {
    type Err = ParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let a: Vec<_> = s
            .split(".")
            .take(4)
            .map(|e| {
                e.split_whitespace()
                    .filter_map(|v| s2n(v))
                    .collect::<Vec<_>>()
            })
            .collect();
        let mut rules = [[0; 4]; 4];
        for i in 0..4 {
            assert!(i == a[i][0]);
            for j in (1..a[i].len()).step_by(2) {
                rules[i][a[i][j + 1]] = a[i][j]
            }
        }
        Ok(Blueprint { rules })
    }
}

#[aoc_generator(day19)]
pub fn input_generator(input: &str) -> Vec<Blueprint> {
    input
        .split("Blueprint")
        .skip(1)
        .map(|b| b.split_once(":").unwrap().1)
        .map(|b| b.parse().unwrap())
        .collect()
}

#[derive(Debug, Hash, PartialEq, Eq, Clone, Copy)]
struct Configuration {
    resource: Vec4,
    robot: Vec4,
    time: usize,
}

impl Configuration {
    fn new() -> Self {
        Configuration {
            resource: [0; 4],
            robot: [1, 0, 0, 0],
            time: 0,
        }
    }

    fn gather(&mut self) {
        for i in 0..4 {
            self.resource[i] += self.robot[i];
        }
        self.time += 1;
    }

    fn build(&mut self, cost: &Vec4, i: usize) {
        for i in 0..4 {
            self.resource[i] -= cost[i];
        }
        self.robot[i] += 1;
    }

    fn may_build(&self, cost: &Vec4) -> bool {
        for i in 0..4 {
            if self.resource[i] < cost[i] {
                return false;
            }
        }
        true
    }

    fn will_build(&self, cost: &Vec4) -> bool {
        for i in 0..4 {
            if self.resource[i] < cost[i] && self.robot[i] == 0 {
                return false;
            }
        }
        true
    }

    fn step(&self, bp: &Blueprint, max: usize) -> Vec<Configuration> {
        let mut ret = vec![];
        for i in 0..4 {
            if i < 3 && (0..4).all(|j| self.robot[i] >= bp.rules[j][i]) {
                // stay reasonable, dont build a robot if current production is greater than
                // the needs
                continue
            }
            if self.will_build(&bp.rules[i]) {
                let mut c = *self;
                while !c.may_build(&bp.rules[i]) {
                    c.gather();
                }
                c.gather();
                c.build(&bp.rules[i], i);
                if c.time <= max {
                    ret.push(c);
                }
            }
        }
        ret
    }

    fn hash(&self) -> [usize; 8] {
        [
            self.resource[0],
            self.resource[1],
            self.resource[2],
            self.robot[0],
            self.robot[1],
            self.robot[2],
            self.robot[3],
            self.time,
        ]
    }
}

fn explore_dyn(bp: &Blueprint, steps: usize) -> usize {
    let mut dp: VecDeque<Configuration> = VecDeque::new();
    let mut hm: HashMap<[usize; 8], usize> = HashMap::new();
    dp.push_back(Configuration::new());
    hm.insert(Configuration::new().hash(), 0);
    let mut estimate = 0;
    while let Some(c) = dp.pop_front() {
        let val = hm.remove(&c.hash()).unwrap();
        if c.time < steps {
            estimate = estimate.max(val + (steps - c.time) * c.robot[3]);
            if val
                + (steps - c.time) * c.robot[3]
                + ((steps - c.time) * (steps - c.time - 1) / 2)
                < estimate
            {
                // Bound
                continue;
            }
            for n in c.step(bp, steps) {
                if let Some(&t) = hm.get(&n.hash()) {
                    if t < n.resource[3] {
                        hm.insert(n.hash(), n.resource[3]);
                    }
                } else {
                    hm.insert(n.hash(), n.resource[3]);
                    dp.push_back(n);
                }
            }
        }
    }
    estimate
}

#[aoc(day19, part1)]
pub fn part1(input: &Vec<Blueprint>) -> usize {
    input
        .iter()
        .map(|bp| explore_dyn(bp, 24))
        .enumerate()
        .map(|(i, v)| (i + 1) * v)
        .sum()
}

#[aoc(day19, part2)]
pub fn part2(input: &Vec<Blueprint>) -> usize {
    input.iter().take(3).map(|bp| explore_dyn(bp, 32)).product()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "Blueprint 1:
  Each ore robot costs 4 ore.
  Each clay robot costs 2 ore.
  Each obsidian robot costs 3 ore and 14 clay.
  Each geode robot costs 2 ore and 7 obsidian.

Blueprint 2:
  Each ore robot costs 2 ore.
  Each clay robot costs 3 ore.
  Each obsidian robot costs 3 ore and 8 clay.
  Each geode robot costs 3 ore and 12 obsidian.";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(&input_generator(EXAMPLE)), 33);
    }
    #[test]
    fn part2_examples() {
        let r: Vec<_> = input_generator(EXAMPLE)
            .iter()
            .take(3)
            .map(|bp| explore_dyn(bp, 32))
            .collect();
        assert_eq!(r, [56, 62]);
    }
}
