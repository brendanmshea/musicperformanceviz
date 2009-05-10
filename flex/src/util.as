/** 
* Generate a random number
* @return Random Number
* @error throws Error if low or high is not provided
*/  
public function randomNumber(low:Number=0, high:Number=100):Number
{
  var low:Number = low;
  var high:Number = high;

  return Math.floor(Math.random() * (1+high-low)) + low;
}

