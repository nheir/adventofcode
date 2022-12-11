use std::{num::ParseIntError, str::FromStr};

#[derive(Debug, Clone, Copy)]
enum Operation {
    Add(usize),
    Mul(usize),
    Square,
}

#[derive(Debug)]
struct Monkey {
    items: Vec<usize>,
    operation: Operation,
    test: usize,
    throw_to: (usize, usize),
    counter: usize,
}

fn is_not_numeric(c: char) -> bool {
    !c.is_numeric()
}

fn numbers<T: FromStr>(s: &str, sep: fn(char) -> bool) -> Vec<T> {
    s.split(sep)
        .map(|s| s.parse::<T>())
        .filter(|n| match n {
            Ok(_) => true,
            _ => false,
        })
        .map(|n| match n {
            Ok(v) => v,
            _ => unreachable!(),
        })
        .collect()
}

impl FromStr for Monkey {
    type Err = ParseIntError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut lines = s.lines();
        // Monkey 0:
        lines.next();
        //   Starting items: 79, 98
        let si = numbers::<usize>(lines.next().unwrap(), is_not_numeric);
        //   Operation: new = old * 19
        let opline = lines.next().unwrap();
        let is_add = opline.find("+");
        let op = numbers::<usize>(opline, is_not_numeric);
        //   Test: divisible by 23
        let test = numbers::<usize>(lines.next().unwrap(), is_not_numeric);
        //     If true: throw to monkey 2
        let tt = numbers::<usize>(lines.next().unwrap(), is_not_numeric);
        //     If false: throw to monkey 3
        let tf = numbers::<usize>(lines.next().unwrap(), is_not_numeric);
        Ok(Monkey {
            items: si,
            operation: match (op.get(0), is_add) {
                (Some(&v), Some(_)) => Operation::Add(v),
                (Some(&v), _) => Operation::Mul(v),
                _ => Operation::Square,
            },
            test: test[0],
            throw_to: (tf[0], tt[0]),
            counter: 0,
        })
    }
}

impl Monkey {
    fn operate(&mut self) {
        self.items = self
            .items
            .iter()
            .map(|&v| match self.operation {
                Operation::Add(c) => v + c,
                Operation::Mul(c) => v * c,
                Operation::Square => v * v,
            })
            .collect();
    }

    fn boredom(&mut self) {
        self.items = self.items.iter().map(|&v| v / 3).collect();
    }

    fn clamp(&mut self, module: usize) {
        self.items = self.items.iter().map(|&v| v % module).collect();
    }

    fn throw(&mut self) -> Vec<(usize, usize)> {
        let u = self
            .items
            .iter()
            .map(|&v| {
                if v % self.test == 0 {
                    (self.throw_to.1, v)
                } else {
                    (self.throw_to.0, v)
                }
            })
            .collect();
        self.items.clear();
        u
    }

    fn inspects(&mut self) -> Vec<(usize, usize)> {
        self.counter += self.items.len();
        self.operate();
        self.boredom();
        self.throw()
    }

    fn inspects_mod(&mut self, module: usize) -> Vec<(usize, usize)> {
        self.counter += self.items.len();
        self.operate();
        self.clamp(module);
        self.throw()
    }
}

#[aoc(day11, part1)]
pub fn part1(input: &str) -> usize {
    let mut monkeys: Vec<Monkey> = input
        .split("\n\n")
        .map(|m| m.parse::<Monkey>().unwrap())
        .collect();
    for _ in 0..20 {
        for i in 0..monkeys.len() {
            for (t, v) in monkeys[i as usize].inspects() {
                monkeys[t as usize].items.push(v);
            }
            monkeys[i as usize].items.clear();
        }
    }
    monkeys.sort_by(|a, b| b.counter.cmp(&a.counter));
    monkeys[0].counter * monkeys[1].counter
}

#[aoc(day11, part2)]
pub fn part2(input: &str) -> usize {
    let mut monkeys: Vec<Monkey> = input
        .split("\n\n")
        .map(|m| m.parse::<Monkey>().unwrap())
        .collect();
    let module = monkeys.iter().map(|m| m.test).product();
    for _ in 0..10000 {
        for i in 0..monkeys.len() {
            for (t, v) in monkeys[i as usize].inspects_mod(module) {
                monkeys[t as usize].items.push(v);
            }
            monkeys[i as usize].items.clear();
        }
    }
    monkeys.sort_by(|a, b| b.counter.cmp(&a.counter));
    monkeys[0].counter * monkeys[1].counter
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE1: &str = "Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&EXAMPLE1), 10605);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(&EXAMPLE1), 2713310158);
    }
}
