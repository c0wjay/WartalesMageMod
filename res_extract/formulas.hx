function weaponPrice( v : Item ) {
	var price = 10 + v.tier * 10;
	if( v.rarity == 1 )
		price += 20;
	if( v.rarity == 2 )
		price += 30;
	return price;
}

function itemPrice( i : Item ) {
	if( i.price != null )
		return i.price;
	var t = i.type;
	while( t != null ) {
		if( t.props.basePrice != null )
			return t.props.basePrice;
		t = t.parentType;
	}
	return null; // will create NaN
}

function craftPrice( c : Craft ) {
	var p = 0;
	for( i in c.recipe )
		p += itemPrice(i.item) * i.qty;
	var real = itemPrice(c.item);
	return p / real - 1;
}