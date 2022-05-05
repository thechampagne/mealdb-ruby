# Copyright 2022 XXIV
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
require_relative "mealdb/version"
require 'net/http'
require 'erb'
require 'json'

class MealDBException < StandardError
  def initialize(message)
    super(message)
  end
end

module MealDB
  class << self

    ##
    # Search meal by name
    #
    # * `s` meal name
    #
    # Raises MealDBException
    def search(s)
      begin
        response = get_request("search.php?s=#{ERB::Util.url_encode(s)}")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        return json['meals']
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # Search meals by first letter
    #
    # * `c` meal letter
    #
    # Raises MealDBException
    def search_by_letter(c)
      begin
        response = get_request("search.php?f=#{c}")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        return json['meals']
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # Search meal details by id
    #
    # * `i` meal id
    #
    # Raises MealDBException
    def search_by_id(i)
      begin
        response = get_request("lookup.php?i=#{i}")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        return json['meals'][0]
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # Search a random meal
    #
    # Raises MealDBException
    def random
      begin
        response = get_request("random.php")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        return json['meals'][0]
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # list of meal categories
    #
    # Raises MealDBException
    def meal_categories
      begin
        response = get_request("categories.php")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['categories'] == nil
          raise MealDBException.new("no results found")
        end
        return json['categories']
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # Filter by ingredient
    #
    # * `s` ingredient name
    #
    # Raises MealDBException
    def filter_by_ingredient(s)
      begin
        response = get_request("filter.php?i=#{ERB::Util.url_encode(s)}")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        return json['meals']
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # Filter by area
    #
    # * `s` area name
    #
    # Raises MealDBException
    def filter_by_area(s)
      begin
        response = get_request("filter.php?a=#{ERB::Util.url_encode(s)}")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        return json['meals']
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # Filter by Category
    #
    # * `s` category name
    #
    # Raises MealDBException
    def filter_by_category(s)
      begin
        response = get_request("filter.php?c=#{ERB::Util.url_encode(s)}")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        return json['meals']
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # List the categories filter
    #
    # Raises MealDBException
    def categories_filter
      begin
        response = get_request("list.php?c=list")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        list = []
        json['meals'].each { |i|
          list.append(i["strCategory"])
        }
        return list
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # List the ingredients filter
    #
    # Raises MealDBException
    def ingredients_filter
      begin
        response = get_request("list.php?i=list")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        return json['meals']
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    ##
    # List the area filter
    #
    # Raises MealDBException
    def area_filter
      begin
        response = get_request("list.php?a=list")
        if response.length == 0
          raise MealDBException.new("no results found")
        end
        json = JSON.parse(response)
        if json['meals'] == nil
          raise MealDBException.new("no results found")
        end
        list = []
        json['meals'].each { |i|
          list.append(i["strArea"])
        }
        return list
      rescue => ex
        raise MealDBException.new(ex.message)
      end
    end

    private def get_request(endpoint)
      uri = URI("https://themealdb.com/api/json/v1/1/#{endpoint}")
      res = Net::HTTP.get_response(uri)
      res.body
    end

  end
end