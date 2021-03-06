class PurchasingMailer < ActionMailer::Base

  def quotation_request(quotation, supplier)
    recipients supplier.email
    from "Purchasing Dept. #{quotation.company.name} <purchasing@cycomsoft.com>"
    reply_to "purchasing@cycomsoft.com"
    subject "Quotation request"
    sent_on Time.now
    body :quotation => quotation, :supplier => supplier
  end
end
