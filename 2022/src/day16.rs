use std::collections::{HashMap, HashSet};

type Valve = (u8, u8);
#[derive(Debug)]
pub struct Node {
    rate: u32,
    neighbors: Vec<Valve>,
}

type Graph = HashMap<Valve, Node>;
type Dist = HashMap<(Valve, Valve), u32>;

pub struct World {
    rates: [u32; 16],
    dist: [[u32; 16]; 16],
}

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

fn read_graph(input: &str) -> Graph {
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

#[aoc_generator(day16)]
pub fn input_generator(input: &str) -> World {
    let graph = read_graph(input);
    let dist = dist(&graph);
    let nodes: HashMap<Valve, u32> = graph
        .iter()
        .filter(|&(v, n)| n.rate > 0 || *v == (b'A', b'A'))
        .map(|(v, n)| (*v, n.rate))
        .collect();
    let mut keys: Vec<_> = nodes.keys().copied().collect();
    keys.sort();
    let names: HashMap<_, _> = keys.iter().enumerate().map(|(a, &b)| (b, a)).collect();

    assert!(names.len() == 16);

    let mut sg = [[0 as u32; 16]; 16];
    for ((a, b), d) in dist {
        if let Some(&i) = names.get(&a) {
            if let Some(&j) = names.get(&b) {
                sg[i][j] = d;
            }
        }
    }
    let mut rates = [0; 16];
    for (k, v) in nodes {
        let &i = names.get(&k).unwrap();
        rates[i] = v;
    }
    World {
        rates: rates,
        dist: sg,
    }
}

fn explore_dyn(world: &World) -> Box<[[[u32; 0x10000]; 31]; 16]> {
    let mut search_array = Box::new([[[0 as u32; 0x10000]; 31]; 16]);
    for set in 0..0x10000 {
        for v in 0..16 {
            for t in 0..31 {
                let mut best: u32 = 0;
                for u in 0..16 {
                    if set & (1 << u) != 0 && world.dist[u][v] < t {
                        let set = set ^ (1 << u);
                        let t = t - world.dist[u][v] - 1;
                        let score = search_array[u][t as usize][set] + t * world.rates[u];
                        best = best.max(score);
                    }
                }
                search_array[v][t as usize][set] = best;
            }
        }
    }
    search_array
}


#[aoc(day16, part1)]
pub fn solve_part1(input: &World) -> u32 {
    let search = explore_dyn(&input);
    *search[0][30].iter().max().unwrap()
}

#[aoc(day16, part2)]
pub fn solve_part2(input: &World) -> u32 {
    let search = explore_dyn(&input);
    let mut best = 0;
    for s in 0..0x8000 {
        let score = search[0][26][s] + search[0][26][0xffff ^ s];
        best = best.max(score);
    }
    best
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
