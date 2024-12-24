#include <stdio.h>
#include <stdlib.h>

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

int main(void) {
    struct str content = read_input();
    struct sv sv = {.data = content.data, .len = content.len};

    struct pair p = sv_split_once(sv, LIT2SV("\n\n"));

    int wire_count = 0;
    struct sv wires[400];
    int values[400];
    for (int i = 0; i < 400; i++)
        values[i] = -1;

    int gate_count = 0;
    struct gate gates[300];

    for (struct pair lp = sv_split_byte(p.left, '\n'); lp.left.len; lp = sv_split_byte(lp.right, '\n')) {
        struct pair wire = sv_split_once(lp.left, LIT2SV(": "));
        int wid = get_wire(wires, &wire_count, wire.left);
        int v = sv_read_int(wire.right);
        values[wid] = v;
    }
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

        gate_count++;

        free(ss);
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

    long count1 = 0;
    for (int i = 0; i < wire_count; i++) {
        if (wires[i].data[0] == 'z' && values[i] == 1) {
            count1 += 1L << ((wires[i].data[1] - '0') * 10 + (wires[i].data[2] - '0'));
        }
    }
    printf("%ld\n", count1);
    
    str_destroy(&content);
    return 0;
}
