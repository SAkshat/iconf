module EventsHelper

  def get_event_status(event)
    return "Ongoing" if event.live?
    return "Upcoming" if event.upcoming?
    "Past"
  end

  def get_duration_string(start_date, end_date)
    if start_date.year == end_date.year
      if start_date.month == end_date.month
        if start_date.day == end_date.day
          return "#{ start_date.day.ordinalize } #{ I18n.t('date.abbr_month_names')[start_date.month] } #{ start_date.year }"
        end
        return duration_string_for_different_days(start_date, end_date)
      else
        return duration_string_for_different_months(start_date, end_date)
      end
    else
      return duration_string_for_different_years(start_date, end_date)
    end
  end

  def event_created_by?(event, user)
    event.creator_id == user.id
  end

  def is_event_changable?(event)
    event.upcoming?
  end

  private

    def duration_string_for_different_years(start_date, end_date)
      "#{ start_date.day.ordinalize } #{ I18n.t('date.abbr_month_names')[start_date.month] } #{ start_date.year }" +
      " - #{ end_date.day.ordinalize } #{ I18n.t('date.abbr_month_names')[end_date.month] } #{ end_date.year }"
    end

    def duration_string_for_different_months(start_date, end_date)
      "#{ start_date.day.ordinalize } #{ I18n.t('date.abbr_month_names')[start_date.month] } - " +
      "#{ end_date.day.ordinalize } #{ I18n.t('date.abbr_month_names')[end_date.month] } #{ end_date.year }"
    end

    def duration_string_for_different_days(start_date, end_date)
      "#{ start_date.day.ordinalize } - #{ end_date.day.ordinalize } " +
      "#{ I18n.t('date.abbr_month_names')[end_date.month] } #{ end_date.year }"
    end

end
