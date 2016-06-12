Note: I've created this MATLAB-code on summer of 2015.
On fall semester of 2015 I wrote a detailed documentation for it
and I submitted it as the homework of my subject
[*Computer Solutions of Tehcnical and Physical Problems*](http://www.ttk.bme.hu/kepzes/MSc/tantargyak/MuszFizProbl.pdf)
on [*BUTE*](https://www.bme.hu/?language=en).

# Hello!

Imagine that one of your friends (someone who is a real type of scientist) shows you a logical game on his computer.
All you can see on screen is some ones and zeros in a well-arranged form.
The goal is to make all digits zero.
To reach this, you can only use 4 commands: *up* (*w*), *down* (*s*), left (*a*) and *right* (*d*).
Quite a difficult task. It takes you half an hour.

But to make the story complete:
Once the task is solved
(all bits zero and and a congratulation message on screen),
your friend trots a Floppy's cube out of his pocket.
(You know, the 3x3x1 version of Rubick's cube.)
He starts to play with it and also with his program at the same time,
and soon you have to realise:
Those binary digits on the screen -- they behave exactly in the same way as Floppy's cube.
They are simply Floppy's cube itself,
as [Neo (and the Architect)](https://www.youtube.com/watch?v=ZKpFFD7aX3c) can see it.

What you can see in this repo:

* TheCode
  * a lot of structural .m files  
    LAPOS.m is the class-definition of Floppy's cube  
    MatrixKocka_3x3x1.m and Solver_3x3x1.m are the script files functioning as engine
  * a header .txt-file which is displayed by my program as a header in MATLAB-console
  * Timer.mat contains a function which can compute performance-related data at run-time  
    This means that you get warning if you set too short time-limit for a too big task  
    in solver (Yes, my software is able to solve Floppy's cube itself.)
* Test  
  Copy the file from this directory to TheCode and run it to see how LAPOS.m works
* Documentation  
  you can find a pdf-documentation  
  (unfortunately only in Hungarian -- I am planning to give a translation as an md-file)
* SampleData  
  this directory contains sample save-files  on which you can try  
  that my software can recognize invalid data or unsolveable cube
* Original  
  you can find my original code written in C, during the fall semester of 2009  
  (the first semester I'd ever written program-code).

To start game just enter directory TheCode with your MATLAB environment
and activate main.m.

Thank you for checking out my repository!
