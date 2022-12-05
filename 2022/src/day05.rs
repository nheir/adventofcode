// I'm definitely doing things wrong here

fn coi(input: &str) -> Vec<u8> {
    let mut ret: Vec<u8> = vec![];
    for (i, c) in input.chars().enumerate() {
        if i & 3 == 1 {
            ret.push(c as u8)
        }
    }
    ret
}

#[aoc_generator(day5)]
pub fn input_generator(input: &str) -> (Vec<Vec<u8>>, Vec<(usize, usize, usize)>) {
    let mut stacks: Vec<Vec<u8>> = vec![];
    for l in input.lines() {
        let cois = coi(l);
        if cois.len() > stacks.len() {
            for _ in (stacks.len()..cois.len()) {
                stacks.push(vec![]);
            }
        }
        if cois[0] == b'1' {
            break;
        }
        for (i, c) in cois.iter().enumerate() {
            if *c != b' ' {
                stacks[i].push(*c);
            }
        }
    }
    let mut r = vec![];
    for (i, v) in stacks.iter().enumerate() {
        let mut v = v.clone();
        v.reverse();
        r.push(v);
    }

    let mut mv: Vec<(usize, usize, usize)> = vec![];
    for l in input.lines() {
        if l.chars().nth(0) != Some('m') {
            continue;
        }
        let sl = l.split(' ');
        let mut sl = sl.filter(|s| s.chars().all(|c| c.is_numeric()));
        mv.push((
            sl.next().unwrap().parse().unwrap(),
            sl.next().unwrap().parse().unwrap(),
            sl.next().unwrap().parse().unwrap(),
        ));
    }
    (r, mv)
}

#[aoc(day5, part1)]
pub fn part1(input: &(Vec<Vec<u8>>, Vec<(usize, usize, usize)>)) -> String {
    let mut a = input.0.iter().map(|v| v.clone()).collect::<Vec<Vec<u8>>>();
    let b = &input.1;
    for (x, y, z) in b {
        for _ in 0..*x {
            let head = a[*y - 1].pop().unwrap();
            a[*z - 1].push(head)
        }
    }
    String::from_utf8(a.iter().map(|v| *v.last().unwrap()).collect()).unwrap()
}

#[aoc(day5, part2)]
pub fn part2(input: &(Vec<Vec<u8>>, Vec<(usize, usize, usize)>)) -> String {
    let mut a = input.0.iter().map(|v| v.clone()).collect::<Vec<Vec<u8>>>();
    let b = &input.1;
    for (x, y, z) in b {
        let p = a[*y - 1].len() - *x;
        for i in 0..*x {
            let v = a[*y - 1][p+i];
            a[*z - 1].push(v);
        }
        for _ in 0..*x {
            a[*y-1].pop();
        }
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
