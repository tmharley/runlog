module ShoesHelper
	def shoe_size_clean(size)
		half = '&frac12;'
		"#{size.floor}#{half if Rational(size).denominator == 2}".html_safe
	end
end
