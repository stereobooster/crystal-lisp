require "arborist"
require "./types"
require "./error"

class Reader
  include Arborist::DSL
  # Arborist::GlobalDebug.enable!

  @@grammar = Arborist::Grammar.new("grammars/mal.g")
  @@eval : Arborist::Visitor(Mal::Type?) = self.build_eval

  def self.build_eval
    eval = Arborist::Visitor(Mal::Type?).new

    eval.on("number") do |ctx|
      Mal::Type.new ctx.text.to_i64
    end

    eval.on("string") do |ctx|
      # TODO use JSON to unescape
      Mal::Type.new ctx.text[1..-2].gsub(/\\(.)/, {
        "\\\"" => "\"",
        "\\n"  => "\n",
        "\\\\" => "\\",
      })
    end

    eval.on("symbol") do |ctx|
      Mal::Type.new case
      when ctx.text == "true"  then true
      when ctx.text == "false" then false
      when ctx.text == "nil"   then nil
      when ctx.text[0] == ':'  then "\u029e#{ctx.text[1..-1]}"
      else
        Mal::Symbol.new ctx.text
      end
    end

    eval.on("keyword") do |ctx|
      Mal::Type.new "\u029e#{ctx.text[1..-1]}"
    end

    eval.on("expression") do |ctx|
      ctx.captures.first_value[0].visit(eval)
    end

    eval.on("quote_symbol") do |ctx|
      Mal::Type.new Mal::Symbol.new case ctx.text
      when "'"  then "quote"
      when "`"  then "quasiquote"
      when "~@" then "splice-unquote"
      when "~"  then "unquote"
      when "@"  then "deref"
      else
        raise "Can't happen"
      end
    end

    eval.on("quote") do |ctx|
      quote_symbol = ctx.captures["quote_symbol"][0].visit(eval).as(Mal::Type)
      val = ctx.captures["expression"][0].visit(eval).as(Mal::Type)
      Mal::Type.new Mal::List.new << quote_symbol << val
    end

    eval.on("expression_or_comment") do |ctx|
      if ctx.captures["expression"]?
        ctx.capture("expression").visit(eval)
      else
        # return nil to skip
        nil
      end
    end

    eval.on("list") do |ctx|
      list = Mal::List.new
      if ctx.captures.first_value?
        ctx.captures.first_value.each do |e|
          val = e.visit(eval)
          if val
            list << val
          end
        end
      end
      Mal::Type.new list
    end

    eval.on("vector") do |ctx|
      list = Mal::Vector.new
      if ctx.captures.first_value?
        ctx.captures.first_value.each do |e|
          val = e.visit(eval)
          if val
            list << val
          end
        end
      end
      Mal::Type.new list
    end

    eval.on("hash_map") do |ctx|
      map = Mal::HashMap.new

      if ctx.captures["pair"]?
        ctx.captures["pair"].each do |pair|
          key = if pair.captures["string"]?
            pair.captures["string"][0].visit(eval).as(Mal::Type).unwrap
          else
            pair.captures["keyword"][0].visit(eval).as(Mal::Type).unwrap
          end
          val = pair.captures["expression"][0].visit(eval).as(Mal::Type)
          case key
          when String
            map[key] = val
          else
            raise "Can't happen"
          end
        end
      end

      Mal::Type.new map
    end

    eval
  end

  def self.parse(str)
    parse_tree = @@grammar.parse(str, :ohm)
    if parse_tree
      # puts parse_tree.try(&.simple_s_exp)
      @@eval.visit(parse_tree)
    else
      raise Mal::ParseException.new @@grammar.print_match_failure_error
    end
  end
end

def read_str(str) : Mal::Type
  result = Reader.parse(str)
  if result.nil?
    Mal::Type.new nil
  else
    result
  end
end

# Arborist::GlobalDebug.enable!
# puts read_str("").to_s
