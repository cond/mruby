##
# Hash(Ext) Test

assert('Hash#merge!') do
  a = { 'abc_key' => 'abc_value', 'cba_key' => 'cba_value' }
  b = { 'cba_key' => 'XXX',  'xyz_key' => 'xyz_value' }

  result_1 = a.merge! b

  a = { 'abc_key' => 'abc_value', 'cba_key' => 'cba_value' }
  result_2 = a.merge!(b) do |key, original, new|
    original
  end

  assert_equal({'abc_key' => 'abc_value', 'cba_key' => 'XXX',
               'xyz_key' => 'xyz_value' }, result_1)
  assert_equal({'abc_key' => 'abc_value', 'cba_key' => 'cba_value',
               'xyz_key' => 'xyz_value' }, result_2)
end

assert('Hash#values_at') do
  h = { "cat" => "feline", "dog" => "canine", "cow" => "bovine" }
  assert_equal ["bovine", "feline"], h.values_at("cow", "cat")

  keys = []
  (0...1000).each { |v| keys.push "#{v}" }
  h = Hash.new { |hash,k| hash[k] = k }
  assert_equal keys, h.values_at(*keys)
end

assert('Hash#fetch') do
  h = { "cat" => "feline", "dog" => "canine", "cow" => "bovine" }
  assert_equal "feline", h.fetch("cat")
  assert_equal "mickey", h.fetch("mouse", "mickey")
  assert_equal "minny", h.fetch("mouse"){"minny"}
  begin
    h.fetch("gnu")
  rescue => e
    assert_kind_of(StandardError, e);
  end
end

assert("Hash#delete_if") do
  base = { 1 => 'one', 2 => false, true => 'true', 'cat' => 99 }
  h1   = { 1 => 'one', 2 => false, true => 'true' }
  h2   = { 2 => false, 'cat' => 99 }
  h3   = { 2 => false }

  h = base.dup
  assert_equal(h, h.delete_if { false })
  assert_equal({}, h.delete_if { true })

  h = base.dup
  assert_equal(h1, h.delete_if {|k,v| k.instance_of?(String) })
  assert_equal(h1, h)

  h = base.dup
  assert_equal(h2, h.delete_if {|k,v| v.instance_of?(String) })
  assert_equal(h2, h)

  h = base.dup
  assert_equal(h3, h.delete_if {|k,v| v })
  assert_equal(h3, h)

  h = base.dup
  n = 0
  h.delete_if {|*a|
    n += 1
    assert_equal(2, a.size)
    assert_equal(base[a[0]], a[1])
    h.shift
    true
  }
  assert_equal(base.size, n)
end
