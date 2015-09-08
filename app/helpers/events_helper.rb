module EventsHelper

  def get_event_status(event)
    return "Ongoing" if event.live?
    return "Upcoming" if event.upcoming?
    "Past"
  end

  def get_duration_string(start_time, end_time)
    if start_time.year == end_time.year
      check_for_month(start_time, end_time)
    else
      return duration_string_for_different_years(start_time, end_time)
    end
  end

  def is_event_owner?(event, user)
    event.creator_id == user.id
  end

  private

    def check_for_month(start_time, end_time)
      if start_time.month == end_time.month
        check_for_day(start_time, end_time)
      else
        return duration_string_for_different_months(start_time, end_time)
      end
    end

    def check_for_day(start_time, end_time)
      if start_time.day == end_time.day
        return "#{ start_time.day.ordinalize } #{ I18n.t('date.abbr_month_names')[start_time.month] } #{ start_time.year }"
      end
      return duration_string_for_different_days(start_time, end_time)
    end

    def duration_string_for_different_years(start_time, end_time)
      "#{ start_time.day.ordinalize } #{ I18n.t('date.abbr_month_names')[start_time.month] } #{ start_time.year } - " + duration_string_for_end_time(end_time)
    end

    def duration_string_for_different_months(start_time, end_time)
      "#{ start_time.day.ordinalize } #{ I18n.t('date.abbr_month_names')[start_time.month] } - " + duration_string_for_end_time(end_time)
    end

    def duration_string_for_different_days(start_time, end_time)
      "#{ start_time.day.ordinalize } - " + duration_string_for_end_time(end_time)
    end

    def duration_string_for_end_time(end_time)
      "#{ end_time.day.ordinalize } #{ I18n.t('date.abbr_month_names')[end_time.month] } #{ end_time.year }"
    end
end
