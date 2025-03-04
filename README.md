# SuperCollider
 
<h1> 140 character assignment<h1>

In all honesty class has been very confusing and I feel quite lost most days. 
This project was quite scary for me to attempt as I felt like we haven't really covered 
where to begin when writting your own codes. 

The code alongs have not made it clear for me how I would start my own code 
and what components are needed for it to work. 

So for this project I took inspiration from the 140 character assignments of other 
students and took bits and pieces from each of them. 

Mainly I struggled with what to choose and how it should sound as I hated how most of them sounded. 
They didn't sound creative enough but also even if they were creative they sounded terrible, and
so did most of the examples. 

Ptpar(({|i|[i*8,Pbind(\scale,[0,2,4,7,9],\degree,Pseq(32.fib.fold(0,10),4)+(2*i+i)-10,\dur,1+2**i%2/6)]}!4).flat).play 

Here is the original code I worked from. I found this code under this link: https://ia601302.us.archive.org/10/items/sc140/sc140_sourcecode.txt
I found it on github after searching for more 140 character projects and this one was from a 
project with the wire where 22 artists presented their 140 characters of code projects. 

My first observation was that I wanted to change the scale. The 
original scale is a major pentatonic and I decided to make it a Dorian Mode scale. C, D, E♭, F, G

So then a problem I faced was how much do I change the code to make it mine but still enjoy how it 
sounds and to be able to show my inspirations from the original code.

My code: 
Ptpar(({|i|[i*8,Pbind(\scale,[0,2,3,5,7],\degree,Pseq(32.fib.fold(0,10),7)+(2*i+i)-5,\dur,1+2**i%2/7)]}!5).flat).play // #supercollider

Messing about with the original code I changed a few things and reach a satisfactory sound. 

First, thing as mentioned above is that I changed the scale to a Dorian mode. 

Second, I changed the degree so that the sequence repeats itself 7 times instead of 4 times. 

Third, I played around with the formula and have to say I didn't hear major differences when I changed the values. But ultimately ended up only changing the 2/7 making it cycle through 2 values but divided by 7 instead of 6. 

And lastly, I changed the duplication factor from !4 to !5. So the pattern plays one more time. 

Even though these were only small adjustments I think it sounds very different. 

Obviously because I took inspiration from someone else's code I did some research so it could understand each line of the code:

Ptpar = is a supercollider function that creates a parallel task, so that multiple things can run simultaneously. 
The !5 defines the task in Ptpar, meaning it should run 5 parallel instances

{|i| ... } = from my reasearch the i is used to create variation in each of the 5 parallel instances 

i*8 = this multiplies the i by 8

Pbind = is a pattern that binds parameters to values
in this case it binds the scale (defines the scale of the pattern), degree (specifies which pitch in teh scale will be used) and dur (specifies duration of each note). 

!5 = used to apply the same pattern 5 times

.flat = used to faltten a nested structure into a single array. From my understanding instead of having each seperate i.e task it flattens them into an array of single arrays, so instead of having seperate parralle tasks running it merges them all into one sequence of events that now play simultaneously. 

.play = makes the sound play

Debbugging:
Some issues I have run in with this code is the latency. For some reason at times some of the sounds take longer than they should and it doesn't keep playing at the same speed. I tried closing the window and restarting but the issue seemed to persist. 

