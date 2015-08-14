
# [DONE TODO - S] Create an email validator and move it there. Then, everywhere use that validator to validate email inputs.

def email_format
  email =~ /\A[A-Z0-9_+%](\.?[A-Z0-9_])*@[A-Z0-9_](\.?[A-Z0-9_])*\.[A-Z]{2,4}\z/i
end
# [DONE: TODO - S] These are called titles, I suppose. Also, move these to user model.
