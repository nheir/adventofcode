use std::{cmp::Ordering, ptr, str::FromStr, string::ParseError};

#[derive(Debug)]
pub enum Tree {
    Leaf(i32),
    Node(Vec<Tree>),
}

fn cmp_list(a: &Vec<Tree>, b: &Vec<Tree>) -> Ordering {
    let s = if a.len() < b.len() { a.len() } else { b.len() };
    for i in 0..s {
        let c = cmp(&a[i], &b[i]);
        if c != Ordering::Equal {
            return c;
        }
    }
    a.len().cmp(&b.len())
}

fn cmp(a: &Tree, b: &Tree) -> Ordering {
    match (&a, &b) {
        (Tree::Leaf(a), Tree::Leaf(b)) => a.cmp(b),
        (Tree::Leaf(_), Tree::Node(b)) => {
            if b.len() == 0 {
                Ordering::Greater
            } else {
                let c = cmp(a, &b[0]);
                if c != Ordering::Equal {
                    c
                } else if b.len() > 1 {
                    Ordering::Less
                } else {
                    Ordering::Equal
                }
            }
        }
        (Tree::Node(a), Tree::Leaf(_)) => {
            if a.len() == 0 {
                Ordering::Less
            } else {
                let c = cmp(&a[0], b);
                if c != Ordering::Equal {
                    c
                } else if a.len() > 1 {
                    Ordering::Greater
                } else {
                    Ordering::Equal
                }
            }
        }
        (Tree::Node(a), Tree::Node(b)) => cmp_list(a, b),
    }
}

fn read_list_tree(input: &[char], i: usize) -> (Vec<Tree>, usize) {
    let mut i = i;
    let mut tt = Vec::new();
    while input[i] != ']' {
        let (t, j) = read_tree(input, i);
        tt.push(t);
        i = j;
        if input[i] == ',' {
            i += 1;
        }
    }
    (tt, i)
}

fn read_tree(input: &[char], i: usize) -> (Tree, usize) {
    match input[i] {
        '[' => {
            let (tt, i) = read_list_tree(input, i + 1);
            (Tree::Node(tt), i + 1)
        }
        _ => {
            let t = input.iter().skip(i).take_while(|&c| c.is_numeric());
            let v = t.collect::<String>();
            (Tree::Leaf(v.parse().unwrap()), i + v.len())
        }
    }
}

impl FromStr for Tree {
    type Err = ParseError;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        Ok(read_tree(&s.chars().collect::<Vec<char>>(), 0).0)
    }
}

#[aoc_generator(day13)]
pub fn input_generator(input: &str) -> Vec<(Tree, Tree)> {
    input
        .split("\n\n")
        .map(|b| {
            let (l1, l2) = b.split_once("\n").unwrap();
            (l1.parse().unwrap(), l2.parse().unwrap())
        })
        .collect()
}

#[aoc(day13, part1)]
pub fn part1(input: &Vec<(Tree, Tree)>) -> usize {
    input
        .iter()
        .enumerate()
        .filter(|(_, (a, b))| cmp(a, b) != Ordering::Greater)
        .map(|(i, _)| i + 1)
        .sum()
}

#[aoc(day13, part2)]
pub fn part2(input: &Vec<(Tree, Tree)>) -> usize {
    let mut vt = vec![];
    let dividers: (&Tree, &Tree) = (&"[[2]]".parse().unwrap(), &"[[6]]".parse().unwrap());
    vt.push(dividers.0);
    vt.push(dividers.1);
    for (u, v) in input {
        vt.push(u);
        vt.push(v);
    }
    vt.sort_by(|&a, &b| cmp(a, b));
    vt.into_iter()
        .enumerate()
        .filter(|&(_, t)| ptr::eq(t, dividers.0) || ptr::eq(t, dividers.1))
        .map(|(i, _)| i + 1)
        .product()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE1: &str = "[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&input_generator(&EXAMPLE1)), 13);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(&input_generator(&EXAMPLE1)), 140);
    }
}
