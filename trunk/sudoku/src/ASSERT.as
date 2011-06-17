package
{
	public function ASSERT(v:Boolean):void
	{
		if(!v)
		{
			throw new Error("ASSERT");
		}
	}
}