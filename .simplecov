SimpleCov.start do
  add_filter %r{^/rpi-media-centre/lib/.*}
  add_filter %r{.*/testing/.*}
  add_filter %r{.*/tests/.*}
  minimum_coverage 100
end
