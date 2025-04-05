//original
Ptpar(({|i|[i*8,Pbind(\scale,[0,2,3,5,7],\degree,Pseq(32.fib.fold(0,10),7)+(2*i+i)-5,\dur,1+2**i%2/7)]}!5).flat).play



//my code
Ptpar(({|i|[i*8,Pbind(\scale,[0,2,3,5,7],\degree,Pseq(32.fib.fold(0,10),7)+(2*i+i)-5,\dur,1+2**i%2/7)]}!5).flat).play // #supercollider