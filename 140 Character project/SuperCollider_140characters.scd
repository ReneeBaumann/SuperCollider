
//my code - play in class
Ptpar(({|i|[i*8,Pbind(\scale,[0,2,3,5,7],\degree,Pseq(32.fib.fold(0,10),7)+(2*i+i)-5,\dur,1+2**i%2/7)]}!5).flat).play // #supercollider

//original code
Ptpar(({|i|[i*8,Pbind(\scale,[0,2,4,7,9],\degree,Pseq(32.fib.fold(0,10),4)+(2*i+i)-10,\dur,1+2**i%2/6)]}!4).flat).play

------------------
//to present in class code:

Ptpar(({|i|[i*8,Pbind(\scale,[0,2,3,5,7],\degree,Pseq(32.fib.fold(0,10),7)+(2*i+i)-5,\dur,1+2**i%2/7)]}!5).flat).play // #supercollider

Ptpar(({|i|[i*8,Pbind(\scale,[0,2,3,5,7],\degree,Pseq(32.fib.fold(0,10),7)+(2*i+i)-5,\dur,1+2**i%2/7)]}!5).flat).play // #supercollider

