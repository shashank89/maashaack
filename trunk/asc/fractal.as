
package com.ggshily.fractal
{

	public class Fractal
	{
		public var width : int;
		public var height : int;
		public var data : Vector.<int>;
		
		public var transparent : Boolean;
		
		private var x0 : Number;
		private var y0 : Number;
		private var r : Number;
		private var maxIter : Number;
	
		public function Fractal(width : int = 640, height : int = 480, x0 : Number = -0.5, y0 : Number = 0, r : Number = 2, maxIter : Number = 1000)
		{
			this.width = width;
			this.height = height;
			this.x0 = x0;
			this.y0 = y0;
			this.r = r;
			this.maxIter = maxIter;
			
			data = new Vector.<int>(width * height);
			calcMandelbrot4(data);
		}
		
		public function getPixel(x : int, y : int) : int
		{
			return data[y * width + x];
		}
		
		public function getPixel32(x : int, y : int) : int
		{
			return 0;
		}
		
		public function calcMandelbrot1(data : Vector.<int>) : void
		{
			for(var y : int = 0; y < height; ++y)
			{
				var str : String = "";
				for(var x : int = 0; x < width; ++x)
				{
					var x1 : Number = (2 * r) * x / width + x0 - r;
					var yr : Number = r * height / width;
					var y1 : Number = (2 * yr) * y / height + y0 - yr;
					var iter : Number = mandelbrot1(x1, y1, maxIter);
					data[y * width + x] = getColor1(iter, maxIter);
					
					str += getColor1(iter, maxIter).toString(16) + " ";
				}
				trace(str);
			}
		}
		
		/////////////////// mandelbrot 1
		
		public function mandelbrot1(x0 : Number, y0 : Number, maxIter : Number) : Number
		{
			var x : Number = x0;
			var y : Number = y0;
			var i : int;
			for(i = 0; i < maxIter; ++i)
			{
				if(x * x + y * y >= 4)
					break;
				var tmp : Number = x * x - y * y + x0;
				y = x * y * 2 + y0;
				x = tmp;
			}
			return i;
		}
		
		public function getColor1(iter : Number, maxIter : Number) : int
		{
			if(iter == maxIter)
				return 0xFF0000;
			else
				return (((iter * 20) % 256) << 16) | (((iter * 15 + 85) % 256) << 8) | ((iter * 30 + 171) % 256);
		}
		
		
		////////////////////// mandelbrot 2
		
		public function modeColor2(iter : Number) : int
		{
			return Math.abs((iter + 255) % 510 - 255);
		}
		
		public function getColor2(iter : Number, maxIter : Number) : int
		{
			if(iter == maxIter)
				return 0xFF0000;
			else
				return (modeColor2(iter * 20) << 16) | (modeColor2(iter * 15 + 85) << 8) | modeColor2(iter * 30 + 171);
		}
		
		public function getColor3(iter : Number, maxIter : Number) : int
		{
			if(iter == maxIter)
				return 0xFF0000;
			else
				return (modeColor2(iter) << 16) | (modeColor2(iter + 85) << 8) | modeColor2(iter + 171);
		}
		
		//////////////////// mandelbrot 3
		
		private static const _divLog2 : Number = 1.0 / Math.log(2.0);
		
		public function log2(x : Number) : Number
		{
			return Math.log(x) * _divLog2;
		}
		
		public function mandelbrot3(x0 : Number, y0 : Number, maxIter : Number) : Number
		{
			var x : Number = x0;
			var y : Number = y0;
			var i : int;
			for(i = 0; i < maxIter; ++i)
			{
				if(x * x + y * y >= 16)
					break;
				var tmp : Number = x * x - y * y + x0;
				y = x * y * 2 + y0;
				x = tmp;
			}
			if(i != maxIter)
				return i + 1 - log2(log2(x * x + y * y));
			else
				return i;
		}
		
		public function calcMandelbrot3(data : Vector.<int>) : void
		{
			iterData = ""
			for(var y : int = 0; y < height; ++y)
			{
				for(var x : int = 0; x < width; ++x)
				{
					var x1 : Number = (2 * r) * x / width + x0 - r;
					var yr : Number = r * height / width;
					var y1 : Number = (2 * yr) * y / height + y0 - yr;
					var iter : Number = mandelbrot3(x1, y1, maxIter);
					data[y * width + x] = getColor2(iter, maxIter);
					
					iterData += getColor2(iter, maxIter).toString(16) + " ";
				}
				iterData += "\n";
			}
		}
		//////////////////// mandelbrot 4
		
		public function sinColor(iter : Number) : Number
		{
			return (Math.sin(iter * 2 * Math.PI / 510 - Math.PI * 0.5) + 1) * 0.5 * 255;
		}
		
		public function getColor4(iter : Number, maxIter : Number) : int
		{
			if(iter == maxIter)
				return 0xFF0000;
			else
				return ((int(sinColor(iter * 20))) << 16) | ((int(sinColor(iter * 15 + 85))) << 8) | int(sinColor(iter * 30 + 171));
		}
		
		public function calcMandelbrot4(data : Vector.<int>) : void
		{
			iterData = ""
			for(var y : int = 0; y < height; ++y)
			{
				for(var x : int = 0; x < width; ++x)
				{
					var x1 : Number = (2 * r) * x / width + x0 - r;
					var yr : Number = r * height / width;
					var y1 : Number = (2 * yr) * y / height + y0 - yr;
					var iter : Number = mandelbrot3(x1, y1, maxIter);
					data[y * width + x] = getColor4(iter, maxIter);
					
					iterData += iter + " ";
				}
				iterData += "\n";
			}
		}
	}
}

include "PNGEncoder.as"

// main

import com.adobe.images.PNGEncoder;

import com.ggshily.fractal.Fractal;

PNGEncoder.encode(new Fractal(1920 * 2, 1280 * 2)).writeFile("output.png");
print("Done, check the output.pgn!");
