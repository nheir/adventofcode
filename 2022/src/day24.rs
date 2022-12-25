use std::collections::{HashSet, VecDeque};

#[derive(Debug)]
pub struct World {
    blizzard: Vec<(i32, i32, i32, i32)>,
    w: i32,
    h: i32,
}

impl World {
    fn is_free(&self, t: i32, i: i32, j: i32) -> bool {
        if i < 0 || i >= self.w {
            return false;
        }
        if i == 0 && j == -1 {
            return true;
        }
        if i == self.w - 1 && j == self.h {
            return true;
        }
        if j < 0 || j >= self.h {
            return false;
        }
        for (x, y, dx, dy) in &self.blizzard {
            if (x + dx * t - i) % self.w == 0 && (y + dy * t - j) % self.h == 0 {
                return false;
            }
        }
        true
    }

    fn neigh(&self, t: i32, i: i32, j: i32) -> Vec<(i32, i32)> {
        let mut ret = vec![];
        for (dx, dy) in [(0, 0), (-1, 0), (1, 0), (0, 1), (0, -1)] {
            if self.is_free(t, i + dx, j + dy) {
                ret.push((i + dx, j + dy))
            }
        }
        ret
    }
}

fn bfs(world: &World, t: i32, start: (i32, i32), end: (i32, i32)) -> i32 {
    let mut queue: VecDeque<(i32, i32, i32)> = VecDeque::new();
    let mut hs: HashSet<(i32, i32, i32)> = HashSet::new();
    let mut mt = t;
    queue.push_back((start.0, start.1, t));
    while let Some((i, j, t)) = queue.pop_front() {
        if (i, j) == end {
            return t;
        }
        if mt < t {
            hs.clear();
            mt = t;
        }
        for (x, y) in world.neigh(t + 1, i, j) {
            if !hs.contains(&(x, y, t + 1)) {
                queue.push_back((x, y, t + 1));
                hs.insert((x, y, t + 1));
            }
        }
    }
    0
}

#[aoc_generator(day24)]
pub fn input_generator(input: &str) -> World {
    let lines = input.lines().collect::<Vec<_>>();
    let h = (lines.len() - 2) as i32;
    let w = (lines[0].len() - 2) as i32;

    let mut world = World {
        blizzard: vec![],
        w,
        h,
    };

    for (j, l) in lines.iter().enumerate() {
        for (i, c) in l.chars().enumerate() {
            match c {
                '>' => world.blizzard.push((i as i32 - 1, j as i32 - 1, 1, 0)),
                '<' => world.blizzard.push((i as i32 - 1, j as i32 - 1, -1, 0)),
                '^' => world.blizzard.push((i as i32 - 1, j as i32 - 1, 0, -1)),
                'v' => world.blizzard.push((i as i32 - 1, j as i32 - 1, 0, 1)),
                _ => (),
            }
        }
    }
    world
}

#[aoc(day24, part1)]
pub fn part1(world: &World) -> i32 {
    bfs(&world, 0, (0, -1), (world.w - 1, world.h))
}

#[aoc(day24, part2)]
pub fn part2(world: &World) -> i32 {
    let t = bfs(&world, 0, (0, -1), (world.w - 1, world.h));
    let t = bfs(&world, t, (world.w - 1, world.h), (0, -1));
    bfs(&world, t, (0, -1), (world.w - 1, world.h))
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = "#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#";

    #[test]
    fn part1_example() {
        assert_eq!(part1(&input_generator(EXAMPLE)), 18);
    }

    #[test]
    fn part2_example() {
        assert_eq!(part2(&input_generator(EXAMPLE)), 54);
    }
}
