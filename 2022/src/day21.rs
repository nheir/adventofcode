use std::{collections::HashMap, convert::TryInto};

#[derive(Debug, Clone, Copy)]
pub enum Tree {
    Leaf(i64),
    Node(u8, [u8; 4], [u8; 4]),
    Human,
}

fn s2a(input: &[u8]) -> [u8; 4] {
    input.try_into().unwrap()
}

#[aoc_generator(day21)]
pub fn input_generator(input: &[u8]) -> HashMap<[u8; 4], Tree> {
    let mut hm = HashMap::new();
    for (name, t) in input.split(|&c| c == b'\n').map(|l| {
        let (name, r) = (&l[0..4], &l[6..]);
        if let Ok(v) = String::from_utf8(r.to_vec()).unwrap().parse() {
            (name, Tree::Leaf(v))
        } else {
            (name, Tree::Node(r[5], s2a(&r[0..4]), s2a(&r[7..11])))
        }
    }) {
        hm.insert(s2a(name), t);
    }
    hm
}

fn eval(input: &HashMap<[u8; 4], Tree>, values: &mut HashMap<[u8; 4], i64>, key: &[u8; 4]) -> i64 {
    if let Some(&v) = values.get(key) {
        v
    } else {
        let v = match input.get(key).unwrap() {
            Tree::Leaf(v) => *v,
            Tree::Node(op, left, right) => {
                let left = eval(input, values, left);
                let right = eval(input, values, right);
                match op {
                    b'+' => left + right,
                    b'-' => left - right,
                    b'*' => left * right,
                    b'/' => left / right,
                    _ => unreachable!(),
                }
            }
            _ => unreachable!(),
        };
        values.insert(*key, v);
        v
    }
}

fn simplify(
    input: &HashMap<[u8; 4], Tree>,
    values: &mut HashMap<[u8; 4], Tree>,
    key: &[u8; 4],
) -> Tree {
    if let Some(&v) = values.get(key) {
        v
    } else {
        if key == b"humn" {
            values.insert(*key, Tree::Human);
            Tree::Human
        } else {
            let v = match input.get(key).unwrap() {
                Tree::Leaf(v) => Tree::Leaf(*v),
                Tree::Node(op, left, right) => {
                    let lt = simplify(input, values, left);
                    let rt = simplify(input, values, right);
                    match (lt, rt) {
                        (Tree::Leaf(left), Tree::Leaf(right)) => match op {
                            b'+' => Tree::Leaf(left + right),
                            b'-' => Tree::Leaf(left - right),
                            b'*' => Tree::Leaf(left * right),
                            b'/' => Tree::Leaf(left / right),
                            _ => unreachable!(),
                        },
                        _ => Tree::Node(*op, *left, *right),
                    }
                }
                Tree::Human => Tree::Human,
            };
            values.insert(*key, v);
            v
        }
    }
}

fn solve(values: &HashMap<[u8; 4], Tree>, key: &[u8; 4], val: i64) -> i64 {
    if key == b"humn" {
        val
    } else {
        if let Tree::Node(op, left, right) = values.get(key).unwrap() {
            match (values.get(left).unwrap(), values.get(right).unwrap()) {
                (_, Tree::Leaf(v)) => match op {
                    b'+' => solve(values, left, val - v),
                    b'-' => solve(values, left, val + v),
                    b'*' => solve(values, left, val / v),
                    b'/' => solve(values, left, val * v),
                    _ => unreachable!(),
                },
                (Tree::Leaf(v), _) => match op {
                    b'+' => solve(values, right, val - v),
                    b'-' => solve(values, right, v - val),
                    b'*' => solve(values, right, val / v),
                    b'/' => solve(values, right, v / val),
                    _ => unreachable!(),
                },
                _ => unreachable!(),
            }
        } else {
            unreachable!()
        }
    }
}

#[aoc(day21, part1)]
pub fn part1(input: &HashMap<[u8; 4], Tree>) -> i64 {
    eval(input, &mut HashMap::new(), &b"root")
}

#[aoc(day21, part2)]
pub fn part2(input: &HashMap<[u8; 4], Tree>) -> i64 {
    let mut values = HashMap::new();
    simplify(input, &mut values, &b"root");
    println!();
    match values.get(b"root").unwrap() {
        Tree::Node(_, left, right) => {
            match (values.get(left).unwrap(), values.get(right).unwrap()) {
                (_, Tree::Leaf(v)) => solve(&values, left, *v),
                (Tree::Leaf(v), _) => solve(&values, right, *v),
                _ => unimplemented!(),
            }
        }
        _ => unimplemented!(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &[u8] = b"root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(&input_generator(EXAMPLE)), 152);
    }
    #[test]
    fn part2_examples() {
        assert_eq!(part2(&input_generator(EXAMPLE)), 301);
    }
}
