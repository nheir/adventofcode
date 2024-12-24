#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "utils.h"

struct gate {
    enum kind {
        AND,
        OR,
        XOR
    } kind;
    int inputs[2];
    int output;
};

int get_wire(struct sv *wires, int *size, struct sv wire) {
    for (int i = 0; i < *size; i++) {
        if (sv_equal(wires[i], wire))
            return i;
    }
    wires[*size] = wire;
    return (*size)++;
}

long eval(long x, long y, struct sv wires[], int wire_count, struct gate gates[], int gate_count) {
    int values[400];
    for (int i = 0; i < 400; i++)
        values[i] = -1;

    int wid = 0;
    for (int i = 0; i < wire_count; i++) {
        if (wires[i].data[0] == 'x') {
            values[wid++] = x & 1;
            x >>= 1;
        } else if (wires[i].data[0] == 'y') {
            values[wid++] = y & 1;
            y >>= 1;
        } else
            break;
    }

    for (int j = 0; j < gate_count; j++) {
        for (int i = 0; i < gate_count; i++) {
            int a = values[gates[i].inputs[0]];
            int b = values[gates[i].inputs[1]];
            int o = gates[i].output;
            if (a < 0 || b < 0)
                continue;
            switch (gates[i].kind) {
            case AND:
                values[o] = a & b;
                break;
            case OR:
                values[o] = a | b;
                break;
            case XOR:
                values[o] = a ^ b;
                break;
            }
        }
    }

    long count = 0;
    for (int i = 0; i < wire_count; i++) {
        if (wires[i].data[0] == 'z' && values[i] == 1) {
            count += 1L << ((wires[i].data[1] - '0') * 10 + (wires[i].data[2] - '0'));
        }
    }
    return count;
}

void display_expr(int wid, struct gate gates[], struct sv wires[], int output_gates[], int size) {
    if (wid < size * 2) {
        printf("%.*s", wires[wid].len, wires[wid].data);
        return;
    }
    struct gate g = gates[output_gates[wid]];
    printf("(");
    display_expr(g.inputs[0], gates, wires, output_gates, size);
    printf(" %c ", g.kind == OR ? '|' : g.kind == AND ? '&' : '^');
    display_expr(g.inputs[1], gates, wires, output_gates, size);
    printf(")");
}

int test_bit(int bit, struct sv wires[], int wire_count, struct gate gates[], int gate_count) {
    if (eval(1L << bit, 0, wires, wire_count, gates, gate_count) != 1L << bit)
        return 0;
    if (eval(0, 1L << bit, wires, wire_count, gates, gate_count) != 1L << bit)
        return 0;
    return 1;
}

void explore(int depth, int used[], int size, struct sv wires[], int wire_count, struct gate gates[], int gate_count) {
    if (depth == 4) {
        for (int i = 0; i < size; i++) {
            if (!test_bit(i, wires, wire_count, gates, gate_count))
                return;
        }
        for (int i = 0; i < 8; i++)
            printf("%.*s", wires[used[i]].len, wires[used[i]].data);
        return;
    }
    for (int i = depth ? used[2 * depth] + 1 : 0; i < gate_count; i++) {
        int seen = 0;
        for (int j = 0; j < depth * 2; j++)
            if (i == used[j])
                seen = 1;
        if (seen)
            continue;
        for (int j = i + 1; j < gate_count; j++) {
            int seen = 0;
            for (int i = 0; i < depth * 2; i++)
                if (j == used[i])
                    seen = 1;
            if (seen)
                continue;
            used[2 * depth] = i;
            used[2 * depth + 1] = j;
            int tmp = gates[i].output;
            gates[i].output = gates[j].output;
            gates[j].output = tmp;
            explore(depth + 1, used, size, wires, wire_count, gates, gate_count);
            gates[j].output = gates[i].output;
            gates[i].output = tmp;
        }
    }
}

void swap(int a, int b, struct gate gates[], int output_gates[]) {
    int ga = output_gates[a];
    int gb = output_gates[b];

    int tmp = gates[ga].output;
    gates[ga].output = gates[gb].output;
    gates[gb].output = tmp;

    output_gates[a] = gb;
    output_gates[b] = ga;
}

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};

    struct pair p = sv_split_once(sv, LIT2SV("\n\n"));

    int wire_count = 0;
    struct sv wires[400];
    int output_gates[400];

    long x = 0;
    long y = 0;

    int gate_count = 0;
    struct gate gates[300];

    int size = 0;

    for (struct pair lp = sv_split_byte(p.left, '\n'); lp.left.len; lp = sv_split_byte(lp.right, '\n')) {
        struct pair wire = sv_split_once(lp.left, LIT2SV(": "));
        get_wire(wires, &wire_count, wire.left);
        long v = sv_read_int(wire.right) << ((wire.left.data[1] - '0') * 10 + (wire.left.data[2] - '0'));
        if (wire.left.data[0] == 'x')
            x += v;
        else
            y += v;
        size++;
    }
    size >>= 1;

    for (struct pair lp = sv_split_byte(p.right, '\n'); lp.left.len; lp = sv_split_byte(lp.right, '\n')) {
        struct pair gate = sv_split_once(lp.left, LIT2SV(" -> "));
        struct sv *ss = sv_split_array(gate.left, LIT2SV(" "), &(size_t){0});

        if (sv_equal(ss[1], LIT2SV("OR")))
            gates[gate_count].kind = OR;
        else if (sv_equal(ss[1], LIT2SV("AND")))
            gates[gate_count].kind = AND;
        else
            gates[gate_count].kind = XOR;

        gates[gate_count].inputs[0] = get_wire(wires, &wire_count, ss[0]);
        gates[gate_count].inputs[1] = get_wire(wires, &wire_count, ss[2]);

        gates[gate_count].output = get_wire(wires, &wire_count, gate.right);
        output_gates[gates[gate_count].output] = gate_count;
        gate_count++;

        free(ss);
    }
    printf("%ld\n", eval(x, y, wires, wire_count, gates, gate_count));

    // Well...
    swap(get_wire(wires, &wire_count, LIT2SV("z11")), get_wire(wires, &wire_count, LIT2SV("wpd")), gates, output_gates);
    swap(get_wire(wires, &wire_count, LIT2SV("mdd")), get_wire(wires, &wire_count, LIT2SV("z19")), gates, output_gates);
    swap(get_wire(wires, &wire_count, LIT2SV("skh")), get_wire(wires, &wire_count, LIT2SV("jqf")), gates, output_gates);
    swap(get_wire(wires, &wire_count, LIT2SV("z37")), get_wire(wires, &wire_count, LIT2SV("wts")), gates, output_gates);

    for (int i = 0; i < 4; i++) {
        int v = (int[4]){11,15,19,37}[i];
        for (int j = 0; j < wire_count; j++) {
            if (wires[j].data[0] == 'z' && ((wires[j].data[1] - '0') * 10 + (wires[j].data[2] - '0')) == v) {
                printf("%.*s: ", wires[j].len, wires[j].data);
                display_expr(j, gates, wires, output_gates, size);
                printf("\n");
            }
        }
    }

    for (int i = 0; i < size; i++) {
        int err = 0;
        if (!(eval(1L << i, 0, wires, wire_count, gates, gate_count) & (1L << i))) {
            printf("%02d: i+0: %lx\n", i, eval(1L << i, 0, wires, wire_count, gates, gate_count));
            err++;
        }
        if (!(eval(0, 1L << i, wires, wire_count, gates, gate_count) & (1L << i))) {
            printf("%02d: 0+i: %lx\n", i, eval(0, 1L << i, wires, wire_count, gates, gate_count));
            err++;
        }
        if (err) {
            for (int j = 0; j < wire_count; j++) {
                if (wires[j].data[0] == 'z' && ((wires[j].data[1] - '0') * 10 + (wires[j].data[2] - '0')) == i) {
                    printf("%.*s: ", wires[j].len, wires[j].data);
                    display_expr(j, gates, wires, output_gates, size);
                    printf("\n");
                }
            }
        }
    }

    srand(time(NULL));
    for (int i = 0; i < 20; i++) {
        long x = rand();
        long y = rand();
        if (x + y != eval(x, y, wires, wire_count, gates, gate_count)) {
            printf("%lx + %lx = %lx != %lx\n", x, y, eval(x, y, wires, wire_count, gates, gate_count), x + y);
        }
    }

    str_destroy(&content);
    return 0;
}
