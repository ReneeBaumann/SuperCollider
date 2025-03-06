Ptpar(({|i|[i*8,Pbind(\scale,[0,2,3,5,7],\degree,Pseq(32.fib.fold(0,10),7)+(2*i+i)-5,\dur,1+2**i%2/7)]}!5).flat).play

Pbind(
    \scale, [0,2,3,5,7],
    \degree, Pseq(32.fib.fold(0,10),7) + 2 * 0 - 5,
    \dur, 1 + 2**0 % 2 / 7
).play;

Ptpar(({|i|[i*8,Pbind(\scale,[0,2,4,7,9],\degree,Pseq(32.fib.fold(0,10),4)+(2*i+i)-10,\dur,1+2**i%2/6)]}!4).flat).play 