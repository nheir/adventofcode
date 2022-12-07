use std::str::Lines;

pub struct Tree {
    size: u32,
    children: Vec<Box<Tree>>,
}

fn read_tree(input: &mut Lines) -> Box<Tree> {
    let mut t = Box::new(Tree {
        size: 0,
        children: vec![],
    });
    while let Some(line) = input.next() {
        if line.starts_with("$") {
            if line[2..4].eq("cd") {
                let n = &line[6..];
                if n.starts_with(".") {
                    break;
                }
                t.children.push(read_tree(input));
            }
        } else {
            let (left, _) = line.split_once(" ").unwrap();
            if left == "dir" {
            } else {
                t.children.push(Box::new(Tree {
                    size: left.parse().unwrap(),
                    children: vec![],
                }))
            }
        }
    }
    t.size = t.children.iter().map(|s| s.size).sum();
    t
}

#[aoc_generator(day7)]
pub fn input_generator(input: &str) -> Box<Tree> {
    let mut a = input.clone().lines();
    read_tree(&mut a)
}

fn sum_below(t: &Tree, m: u32) -> u32 {
    t.children.iter().map(|t| sum_below(t, m)).sum::<u32>()
        + if t.children.len() > 0 && t.size <= m {
            t.size
        } else {
            0
        }
}

#[aoc(day7, part1)]
pub fn part1(input: &Tree) -> u32 {
    sum_below(input, 100000)
}

fn min_above(t: &Tree, m: u32) -> u32 {
    let v = t
        .children
        .iter()
        .filter(|t| t.children.len() > 0 && t.size > m)
        .map(|t| min_above(t, m))
        .min();
    if let Some(min) = v {
        min
    } else {
        t.size
    }
}

#[aoc(day7, part2)]
pub fn part2(input: &Tree) -> u32 {
    min_above(input, 30000000 - (70000000 - input.size))
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(&input_generator(&EXAMPLE)), 95437);
    }
}
