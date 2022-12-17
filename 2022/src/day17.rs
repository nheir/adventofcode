use std::collections::HashMap;

type Row = u8;
type Cave = Vec<Row>;
struct Shape {
    mat: [u8; 4],
    height: usize,
}

impl Shape {
    fn hline() -> Self {
        Shape {
            mat: [0b11110, 0, 0, 0],
            height: 1,
        }
    }
    fn plus() -> Self {
        Shape {
            mat: [0b1000, 0b11100, 0b1000, 0],
            height: 3,
        }
    }
    fn corner() -> Self {
        Shape {
            mat: [0b11100, 0b100, 0b100, 0],
            height: 3,
        }
    }
    fn vline() -> Self {
        Shape {
            mat: [0b10000, 0b10000, 0b10000, 0b10000],
            height: 4,
        }
    }
    fn square() -> Self {
        Shape {
            mat: [0b11000, 0b11000, 0, 0],
            height: 2,
        }
    }

    fn can_left(&self, cave: &[u8]) -> bool {
        for i in 0..4 {
            if self.mat[i] & 0b1000000 != 0 {
                return false;
            }
            if (self.mat[i] << 1) & cave[i] != 0 {
                return false;
            }
        }
        true
    }
    fn can_right(&self, cave: &[u8]) -> bool {
        for i in 0..4 {
            if self.mat[i] & 0b1 != 0 {
                return false;
            }
            if (self.mat[i] >> 1) & cave[i] != 0 {
                return false;
            }
        }
        true
    }

    fn can_down(&self, cave: &[u8]) -> bool {
        for i in 0..4 {
            if self.mat[i] & cave[i] != 0 {
                return false;
            }
        }
        true
    }

    fn left(&mut self) -> &mut Self {
        for i in 0..4 {
            self.mat[i] <<= 1;
        }
        self
    }

    fn right(&mut self) -> &mut Self {
        for i in 0..4 {
            self.mat[i] >>= 1;
        }
        self
    }
}

struct World {
    cave: Cave,
    height: usize,
    shape: Shape,
    shape_y: usize,
    pruned: usize,
}

impl World {
    fn new(shape: Shape) -> Self {
        World {
            cave: vec![0, 0, 0, 0, 0, 0, 0],
            height: 0,
            shape: shape,
            shape_y: 3,
            pruned: 0
        }
    }

    fn jet(&mut self, input: &u8) {
        match input {
            b'>' => {
                if self
                    .shape
                    .can_right(&self.cave[self.shape_y..self.shape_y + 4])
                {
                    self.shape.right();
                }
            }
            b'<' => {
                if self
                    .shape
                    .can_left(&self.cave[self.shape_y..self.shape_y + 4])
                {
                    self.shape.left();
                }
            }
            b'v' => {
                while self.shape_y > 0
                    && self
                        .shape
                        .can_down(&self.cave[self.shape_y - 1..self.shape_y + 3])
                {
                    self.shape_y -= 1
                }
            }
            _ => (),
        }
    }

    fn fall(&mut self) -> bool {
        if self.shape_y > 0
            && self
                .shape
                .can_down(&self.cave[self.shape_y - 1..self.shape_y + 3])
        {
            self.shape_y -= 1;
            false
        } else {
            for i in 0..4 {
                self.cave[self.shape_y + i] |= self.shape.mat[i]
            }
            if self.height < self.shape_y + self.shape.height {
                for _ in self.height..(self.shape_y + self.shape.height) {
                    self.cave.push(0);
                }
                self.height = self.shape_y + self.shape.height
            }
            true
        }
    }

    fn prune(&mut self) {
        let mut top = 0;
        for i in (0..self.height).rev() {
            top |= self.cave[i];
            if top == 0b1111111 {
                self.cave = self.cave[i..].to_vec();
                self.pruned += i;
                self.height -= i;
                break;
            }
        }
    }

    fn insert_shape(&mut self, shape: Shape) {
        self.shape = shape;
        self.shape_y = self.height + 3;
    }

    fn size(&self) -> usize {
        self.height + self.pruned
    }
}

#[aoc(day17, part1: Bytes)]
pub fn part1(input: &[u8]) -> usize {
    let shapes = [
        Shape::hline,
        Shape::plus,
        Shape::corner,
        Shape::vline,
        Shape::square,
    ];
    let mut shape_index = 0;
    let mut world = World::new(shapes[0]());
    for c in input.iter().cycle() {
        world.jet(c);
        if world.fall() {
            shape_index += 1;
            world.insert_shape(shapes[shape_index % shapes.len()]());
            if shape_index >= 2022 {
                break;
            }
        }
    }
    world.height
}

#[aoc(day17, part2: Bytes)]
pub fn part2(input: &[u8]) -> usize {
    let mut hm: HashMap<(usize, usize, usize), (usize, usize)> = HashMap::new();
    hm.insert((0, 0, 0), (0, 0));
    let shapes = [
        Shape::hline,
        Shape::plus,
        Shape::corner,
        Shape::vline,
        Shape::square,
    ];
    let mut shape_index = 0;
    let mut world = World::new(shapes[0]());
    for (j, c) in input.iter().enumerate().cycle() {
        world.jet(c);
        if world.fall() {
            world.prune();

            shape_index += 1;
            world.insert_shape(shapes[shape_index % shapes.len()]());

            let key = (world.height, shape_index % shapes.len(), j);
            if let Some((si, h)) = hm.get(&key) {
                let delta = shape_index - si;
                let goal: usize = 1000000000000;
                if (goal - si) % delta == 0 {
                    return (goal - si) / delta * (world.size() - h) + h;
                }
            }
            
            hm.insert(key, (shape_index, world.size()));
        }
    }
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    const EXAMPLE: &str = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>";

    #[test]
    fn part1_examples() {
        assert_eq!(part1(&EXAMPLE.as_bytes()), 3068);
    }
    #[test]
    fn part2_examples() {
        assert_eq!(part2(&EXAMPLE.as_bytes()), 1514285714288);
    }
}
