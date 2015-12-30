class Array
  def each_pair_overlapped
    each_with_index do |e, idx|
      yield e, at(idx + 1) if (idx + 1) < size
    end
  end
end
