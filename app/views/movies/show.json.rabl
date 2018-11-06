object @movie
attributes :id, :title, :release_date

node(:rented_by) { |movie| }