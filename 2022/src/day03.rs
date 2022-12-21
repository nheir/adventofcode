type Compartment = [u32; 52];
type Rucksack = (Compartment, Compartment);

pub fn gen_compartment(line: &str) -> Compartment {
    let mut ret = [0; 52];
    for c in line.chars() {
        let i = c as usize;
        let k = if c.is_ascii_lowercase() {
            i - ('a' as usize)
        } else if c.is_ascii_uppercase() {
            i - ('A' as usize) + 26
        } else {
            unreachable!()
        };
        ret[k] += 1;
    }
    ret
}

#[aoc_generator(day3)]
pub fn input_generator(input: &str) -> Vec<Rucksack> {
    let mut ret: Vec<Rucksack> = Vec::new();

    for s in input.lines() {
        let len = s.len() / 2;
        let left = &s[..len];
        let right = &s[len..];
        ret.push((gen_compartment(left), gen_compartment(right)))
    }
    ret
}

#[aoc(day3, part1)]
pub fn part1(input: &Vec<Rucksack>) -> u32 {
    input
        .iter()
        .map(
            |(l, r)| match (0 as usize..52).find(|i| l[*i] > 0 && r[*i] > 0) {
                Some(i) => i as u32 + 1,
                _ => unreachable!(),
            },
        )
        .sum()
}

fn sumt((a, b): &Rucksack) -> Compartment {
    let mut r = [0; 52];
    for i in 0..52 {
        r[i] = a[i] + b[i]
    }
    r
}

type Group = (Compartment, Compartment, Compartment);
fn packlines(input: &Vec<Rucksack>) -> Vec<Group> {
    let mut it = input.iter();
    let mut ret = vec![];
    for _ in 0..input.len() / 3 {
        ret.push((
            sumt(it.next().unwrap()),
            sumt(it.next().unwrap()),
            sumt(it.next().unwrap()),
        ))
    }
    ret
}

#[aoc(day3, part2)]
pub fn part2(input: &Vec<Rucksack>) -> u32 {
    let input = packlines(input);
    input
        .iter()
        .map(
            |(a, b, c)| match (0 as usize..52).find(|i| a[*i] > 0 && b[*i] > 0 && c[*i] > 0) {
                Some(i) => i as u32 + 1,
                _ => unreachable!(),
            },
        )
        .sum()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&input_generator(EXAMPLE)), 157);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(&input_generator(EXAMPLE)), 70);
    }
}
