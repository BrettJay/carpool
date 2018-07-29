module VideoHelper
  def videos
    data.videos.sort_by { |slug, video | video.release_date }.reverse
  end

  def recent_videos
    videos.take(4)
  end

  def videos_in_category(category)
    videos.select{ |slug, video | video.category == category }
  end

  def videos_in_series(series)
    videos.select{ |slug, video | video.series == series }.reverse
  end

  def series_title_for(slug)
    series = data.series.select{ | series | series.slug == slug }
    series[0].title
  end
end
