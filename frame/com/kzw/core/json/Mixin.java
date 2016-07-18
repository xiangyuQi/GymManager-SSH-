package com.kzw.core.json;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFilter;

public class Mixin {

	public static List<Class<?>> all = new ArrayList<Class<?>>();
	static {
		all.add(Mixin0.class);
		all.add(Mixin1.class);
		all.add(Mixin2.class);
		all.add(Mixin3.class);
		all.add(Mixin4.class);
		all.add(Mixin5.class);
		all.add(Mixin6.class);
		all.add(Mixin7.class);
		all.add(Mixin8.class);
		all.add(Mixin9.class);
	}

	@JsonFilter("filter0")
	public static interface Mixin0 {
	}

	@JsonFilter("filter1")
	public static interface Mixin1 {
	}

	@JsonFilter("filter2")
	public static interface Mixin2 {
	}

	@JsonFilter("filter3")
	public static interface Mixin3 {
	}

	@JsonFilter("filter4")
	public static interface Mixin4 {
	}

	@JsonFilter("filter5")
	public static interface Mixin5 {
	}

	@JsonFilter("filter6")
	public static interface Mixin6 {
	}

	@JsonFilter("filter7")
	public static interface Mixin7 {
	}

	@JsonFilter("filter8")
	public static interface Mixin8 {
	}

	@JsonFilter("filter9")
	public static interface Mixin9 {
	}

}
