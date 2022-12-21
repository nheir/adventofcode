#[derive(Debug, Clone, Copy)]
pub struct Item {
    value: i64,
    next: usize,
    prev: usize,
}

#[aoc_generator(day20)]
pub fn input_generator(input: &str) -> Vec<Item> {
    let v: Vec<i64> = input.lines().map(|l| l.parse().unwrap()).collect();
    let len = v.len();
    v.iter()
        .enumerate()
        .map(|(i, &v)| Item {
            value: v,
            next: (i + 1) % len,
            prev: (i + len - 1) % len,
        })
        .collect()
}

fn mix(list: &mut Vec<Item>) {
    let len = list.len() as i64 - 1;
    for i in 0..list.len() {
        let v = list[i].value % len;
        let mut dest = i;
        for _ in 0..v {
            dest = list[dest].next;
        }
        for _ in v..=0 {
            dest = list[dest].prev;
        }
        let iprev = list[i].prev;
        let inext = list[i].next;
        list[iprev].next = list[i].next;
        list[inext].prev = list[i].prev;
        let dnext = list[dest].next;
        list[dnext].prev = i;
        list[dest].next = i;
        list[i].next = dnext;
        list[i].prev = dest;
    }
}

#[aoc(day20, part1)]
pub fn part1(input: &Vec<Item>) -> i64 {
    let mut list = input.clone();
    mix(&mut list);
    let start = list
        .iter()
        .enumerate()
        .find(|(_, v)| v.value == 0)
        .unwrap()
        .0;
    let mut ret = 0;
    let mut v = start;
    for i in 0..=3000 {
        if i == 1000 || i == 2000 || i == 3000 {
            ret += list[v].value;
        }
        v = list[v].next
    }
    ret
}

#[aoc(day20, part2)]
pub fn part2(input: &Vec<Item>) -> i64 {
    let mut list = input.clone();
    for v in list.iter_mut() {
        v.value *= 811589153;
    }
    for _ in 0..10 {
        mix(&mut list);
    }
    let start = list
        .iter()
        .enumerate()
        .find(|(_, v)| v.value == 0)
        .unwrap()
        .0;
    let mut ret = 0;
    let mut v = start;
    for i in 0..=3000 {
        if i == 1000 || i == 2000 || i == 3000 {
            ret += list[v].value;
        }
        v = list[v].next
    }
    ret
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "1
2
-3
3
-2
0
4";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&input_generator(EXAMPLE)), 3);
    }
    #[test]
    fn part2_example() {
        assert_eq!(part2(&input_generator(EXAMPLE)), 1623178306);
    }
}
