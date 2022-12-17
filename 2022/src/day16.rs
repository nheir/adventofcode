use std::collections::{HashMap, HashSet};

type Valve = (u8, u8);
#[derive(Debug)]
pub struct Node {
    rate: u32,
    neighbors: Vec<Valve>,
}
type Graph = HashMap<Valve, Node>;
type Dist = HashMap<(Valve, Valve), u32>;

fn dist(g: &Graph) -> Dist {
    let mut d = Dist::new();
    for &k in g.keys() {
        d.insert((k, k), 0);
    }
    for (&v, n) in g {
        for &w in &n.neighbors {
            d.insert((v, w), 1);
            d.insert((w, v), 1);
        }
    }
    for _ in 0..g.len() {
        for &u in g.keys() {
            for &v in g.keys() {
                for &w in g.keys() {
                    if d.contains_key(&(u, w)) && d.contains_key(&(w, v)) {
                        d.insert(
                            (u, v),
                            *d.get(&(u, v))
                                .unwrap_or(&(g.len() as u32))
                                .min(&(d.get(&(u, w)).unwrap() + d.get(&(w, v)).unwrap())),
                        );
                    }
                }
            }
        }
    }
    d
}

#[aoc_generator(day16)]
pub fn input_generator(input: &str) -> Graph {
    let mut hm: Graph = Graph::new();
    for l in input.lines() {
        let l: Vec<_> = l
            .bytes()
            .skip(6)
            .filter(|&c| c == b' ' || c.is_ascii_digit() || c.is_ascii_uppercase())
            .collect();
        let mut it = l.split(|&c| c == b' ').filter(|s| s.len() > 0);
        let valve = it.next().unwrap();
        let rate: u32 = String::from_utf8(it.next().unwrap().to_vec())
            .unwrap()
            .parse()
            .unwrap();
        let mut neigh = vec![];
        for v in it {
            neigh.push((v[0], v[1]))
        }
        hm.insert(
            (valve[0], valve[1]),
            Node {
                rate: rate,
                neighbors: neigh,
            },
        );
    }
    hm
}

fn explore(
    nodes: &HashMap<Valve, u32>,
    dist: &Dist,
    current: Valve,
    opened: &mut HashSet<Valve>,
    score: u32,
    max: u32,
    step: u32,
) -> u32 {
    let mut max = max.max(score);
    for (&c, &rate) in nodes {
        let &d = dist.get(&(current, c)).unwrap();
        if rate > 0 && !opened.contains(&c) && d < step {
            let delta = (step - d - 1) * rate;
            opened.insert(c);
            max = explore(nodes, dist, c, opened, score + delta, max, step - d - 1);
            opened.remove(&c);
        }
    }
    max
}

// exhaustive search doesn't end but we luckily get the best result in the first few minutes
fn explore_duo(
    nodes: &HashMap<Valve, u32>,
    dist: &Dist,
    current: (Valve, Valve),
    opened: &mut HashSet<Valve>,
    score: u32,
    max: u32,
    step: (u32, u32),
) -> u32 {
    if max < score {
        dbg!(score);
    }
    let mut max = max.max(score);
    for (&c, &rate) in nodes {
        let &d = dist.get(&(current.0, c)).unwrap();
        if d < step.0 && !opened.contains(&c) {
            let delta = (step.0 - d - 1) * rate;
            opened.insert(c);
            max = explore_duo(
                nodes,
                dist,
                (c, current.1),
                opened,
                score + delta,
                max,
                (step.0 - d - 1, if step.0 < step.1 { 0 } else { step.1 }),
            );
            opened.remove(&c);
        }
        let &d = dist.get(&(current.1, c)).unwrap();
        if d < step.1 && !opened.contains(&c) {
            let delta = (step.1 - d - 1) * rate;
            opened.insert(c);
            max = explore_duo(
                nodes,
                dist,
                (current.0, c),
                opened,
                score + delta,
                max,
                (if step.1 < step.0 { 0 } else { step.0 }, step.1 - d - 1),
            );
            opened.remove(&c);
        }
    }
    max
}

#[aoc(day16, part1)]
pub fn solve_part1(input: &Graph) -> u32 {
    let dist = dist(input);
    let nodes: HashMap<Valve, u32> = input
        .iter()
        .filter(|(_, n)| n.rate > 0)
        .map(|(v, n)| (*v, n.rate))
        .collect();
    explore(&nodes, &dist, (b'A', b'A'), &mut HashSet::new(), 0, 0, 30)
}

#[aoc(day16, part2)]
pub fn solve_part2(input: &Graph) -> u32 {
    let dist = dist(input);
    let nodes: HashMap<Valve, u32> = input
        .iter()
        .filter(|(_, n)| n.rate > 0)
        .map(|(v, n)| (*v, n.rate))
        .collect();
    explore_duo(
        &nodes,
        &dist,
        ((b'A', b'A'), (b'A', b'A')),
        &mut HashSet::new(),
        0,
        0,
        (26, 26),
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II";

    #[test]
    fn part1_example() {
        assert_eq!(solve_part1(&input_generator(&EXAMPLE)), 1651);
    }

    #[test]
    fn part2_example() {
        assert_eq!(solve_part2(&input_generator(&EXAMPLE)), 1707);
    }
}
