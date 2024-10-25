depth = -100;
rCollide = oWall;

switch rainLayer {

	case 0:
		depth = -100;
		rCollide = oWall;
		break;
	case 1:
		depth = 300;
		rCollide = oLayer1;
		break;
	case -1:
		depth = 500;
		rCollide = oLayerN1;
		break;
		

}