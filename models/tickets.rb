# require_relative('customers.rb')
# require_relative('films.rb')
require_relative('../db/sql_runner')

class Ticket
  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
  end

  def save()
  sql = "INSERT INTO tickets
  (
    customer_id,
    film_id
    )
    VALUES
    (
      $1, $2
      )
      RETURNING id"
      values = [@customer_id, @film_id]
      result = SqlRunner.run(sql, values)
      @id = result[0]['id'].to_i
    end

    def update()
      sql =
      "UPDATE tickets
      SET (customer_id, film_id)
      = ($1, $2)
      WHERE id = $3;"
      values = [@customer_id, @film_id, @id]
      SqlRunner.run(sql, values)
    end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values)
    return Customer.new(customer)
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film = SqlRunner.run(sql, values)
    return Film.new(film)
  end

  def Ticket.all
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    result = tickets.map { |ticket| Ticket.new(ticket) }
    return result
  end

  # def count()
  # sql = "SELECT COUNT(customer_id) as "Total Tickets"
  # FROM tickets
  # WHERE id = $1";
  # values = [@customer_id]
  # result = SqlRunner.run(sql, values)
  # return result
  # end

end #class end
