module ApplicationHelper
    def format_date(date)
        date.strftime('%e %B %Y')
    end
end
