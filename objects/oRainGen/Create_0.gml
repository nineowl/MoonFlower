dropTimer = 0;
//freqMin=25; //The higher this number the slower
//freqMax=10 //The lower this number the faster
dropFreq = random_range(freqMax,freqMin);
freqSet = true;
//variance = 10;
//fallSpd = 9;


/*
How rain layering works:
So currently there are 3 rain layers.
0 is the basic layer, allowing the rain to collide with the wall.
-1 is the background layer allowing the rain to fall behind wall objects.
1 is the forground layer allowing rain to fall in front of foreground objects.

With objects oLayer1 and oLayerN1 you can place them on top of tiles that you want the rain to splash onto.
This allows rain to splash onto platforms below wall collisions.

ideally there should be 5 total layers so that rain can keep falling in the background and foreground

objects oLayer1 and oLayerN1 can most likely be consolidated into a single rain layer object, and we can
instead of checking for the object, we could check for the object property. Although separate objects seems
easier due to the ability to color code.

*/