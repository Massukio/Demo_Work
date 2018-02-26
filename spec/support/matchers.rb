# Matcher function for search returning one result item #
RSpec::Matchers.define :have_one_search_result do
  match do |page|
    expect(page.get_total_results).to eq(1)
  end
  failure_message do |page|
    page.access_filter_all_content.click
    if page.get_total_results.should == 1
      "Found DOI after changing to all content for the DOI #{page.search_box.value}."
    else
      "Expected at least one result(s) to be returned for the DOI #{page.search_box.value}."
    end
  end
  failure_message_when_negated do |page|
    "Expected no results to be returned for the DOI #{page.search_box.value}."
  end
end

# Matcher function for data matrix validation #
RSpec::Matchers.define :have_matching_search_result_with do |text,field|
  match do |page|
    expect(page.data_matrix_validation(text,field)).to eq(true)
  end
  failure_message do |page|
    case field
      when 'title','review-title', 'review-no-title'
        "| #{field} | Expected: #{text}| Actual: #{page.result_title[0].text}|"
      when 'author'
        "| #{field} | Expected: #{text}| Actual: #{page.result_author[0].text}|"
      when 'no-author'
        'Expected result to not have any author.'
      when 'volume', 'issue', 'pubdate', 'pages', 'metadata'
        "| #{field} | Expected: #{text}| Actual: #{page.result_metadata[0].text}|"
      when 'editor'
        "| #{field} | Expected: #{text}| Actual: #{page.result_editor[0].text}|"
      when 'book-pub', 'book-pubdate'
        "| #{field} | Expected: #{text}| Actual: #{page.book_result_metadata[0].text}|"
      when 'book-volume'
        "| #{field} | Expected: #{text}| Actual: #{page.book_volume[0].text}|"
      when 'book-edition'
        "| #{field} | Expected: #{text}| Actual: #{page.book_edition[0].text}|"
      when 'reviewed-title'
        "| #{field} | Expected: #{text}| Actual: #{page.result_reviewed_title[0].text}|"
      else
        "| #{field} | <-- Unexpected field provided||"
    end
  end
  failure_message_when_negated do |page|
    case field
      when 'title','review-title', 'review-no-title'
        "Expected none of the results to have #{field} as #{text}, but got #{page.result_title[0].text}."
      when 'author','no-author'
        "Expected none of the results to have #{field} as #{text}, but got #{page.result_author[0].text}."
      when 'volume', 'issue', 'pubdate', 'pages', 'metadata'
        "Expected none of the results to have #{field} as #{text}, but got #{page.result_metadata[0].text}."
      when 'editor'
        "Expected none of the results to have #{field} as #{text}, but got #{page.result_editor[0].text}."
      when 'book-pub', 'book-pubdate'
        "Expected none of the results to have #{field} as #{text}, but got #{page.book_result_metadata[0].text}."
      when 'book-volume'
        "Expected none of the results to have #{field} as #{text}, but got #{page.book_volume[0].text}."
      when 'book-edition'
        "Expected none of the results to have #{field} as #{text}, but got #{page.book_edition[0].text}."
      when 'reviewed-title'
        "Expected none of the results to have #{field} as #{text}, but got #{page.result_reviewed_title[0].text}."
      else
        "Unexpected field '#{field} provided."
    end
  end
end

# Matcher function for search returning atleast one result item #
RSpec::Matchers.define :have_atleast_one_search_result do
  match do |page|
    page.get_total_results.should >= 1
  end
  failure_message do |page|
    "Expected at least one result(s) to be returned for the search term #{page.search_box.value}."
  end
  failure_message_when_negated do |page|
    "Expected no results to be returned for the search term #{page.search_box.value}."
  end
end

RSpec::Matchers.define :have_atleast_one_sus_search_result do
  match do |page|
    page.get_sus_total_results.should >= 1
  end
  failure_message do |page|
    "Expected at least one result(s) to be returned for the search term #{page.search_box.value}."
  end
  failure_message_when_negated do |page|
    "Expected no results to be returned for the search term #{page.search_box.value}."
  end
end

RSpec::Matchers.define :have_atleast_one_ana_search_result do
  match do |page|
    page.get_analyzer_total_results.should >= 1
  end
  failure_message do |page|
    "Expected at least one result(s) to be returned for the search term #{page.term_Label.span}."
  end
  failure_message_when_negated do |page|
    "Expected no results to be returned for the search term #{page.term_Label.span}."
  end
end

# Should be used when you have an array (or array of arrays) of results,
# valid results can contain hashes of key value pairs where the value is key=>values (e.g. [{search.v1=>{key=>value, key2=>value}}])
# string replacement is used for the key in the message provided to give the error message
# if no message is provided, the array is returned in flattened form.
# Note: if header is true, the message provided is displayed in front of the collection.
RSpec::Matchers.define :be_empty do |message, header=true|
  match do |collection|
    expect(collection.flatten.empty?).to eq(true)
  end

  failure_message do |collection|
    if header
      "#{message}\n #{JSON.pretty_generate(collection)}"
    else
      JSON.pretty_generate(collection.flatten.map {|v| v.map{|_, value| value.reduce(message){|str,(key,result)| str.gsub(/\b#{key}\b/,result.to_s)}}}.flatten)
    end
  end

  failure_message_when_negated do
    message.nil? ? 'Collection did not have contents but was expected to.' : message
  end
end

# Matcher function for data matrix validation for metatags: checking error message container #
RSpec::Matchers.define :not_contain_messages do |error_messages|
  match do
    error_messages.empty?.should == true
  end
  failure_message do
    error_messages
  end
  failure_message_when_negated do
    "Sorry, didn't find any messages"
  end
end

RSpec::Matchers.define :contain_hash do |expected_hash|
  match do |actual_hash|
    actual_hash.merge(expected_hash) == actual_hash
  end
  failure_message do
    'hash does not contain given data'
  end
  failure_message_when_negated do
    'hash unexpectedly contains given data'
  end
end

RSpec::Matchers.define :have_role do |role_value|
  match do |account_list|
    account_list.each do |account|
      if account.key?(:role)
        return true if account[:role].eql?(role_value)
      end
    end
    return false
  end
  failure_message do
    "account list does not contain '#{role_value}' role"
  end
  failure_message_when_negated do
    "account list unexpectedly contains '#{role_value}' role"
  end
end