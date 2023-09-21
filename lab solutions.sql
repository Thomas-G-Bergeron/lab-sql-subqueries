use sakila;

-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
select count(inventory_id) from
 (    SELECT i.inventory_id, f.title from inventory as i
      join film as f on i.film_id = f.film_id
      where f.title = "HUNCHBACK IMPOSSIBLE"
      ) as i;
      
-- List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT * FROM film where length >(
  SELECT avg(length) AS Average
  FROM film) ;
  
-- Use a subquery to display all actors who appear in the film "Alone Trip".

select * from (Select f.title, a.first_name, a.last_name from film_actor as fa 
join film as f on fa.film_id = f.film_id
join actor as a on fa.actor_id = a.actor_id 
) as sub1
where title = "ALONE TRIP";

-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.

select * from (Select c.name, f.title from category as c
join film_category as fc on c.category_id = fc.category_id
join film as f on fc.film_id  = f.film_id )as sub1
where name = "Family";

-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

select * from (select c.first_name, c.last_name, c.email, co.country from customer as c
join address as a on c.address_id = a.address_id
join city as ci on a.city_id = ci.city_id
join country as co on ci.country_id = co.country_id) as sub2
where country = "Canada";

-- Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.


Select f.title from film_actor as fa 
left join film as f on fa.film_id = f.film_id 
where actor_id in (
	Select actor_id from (
		select actor_id, count(film_id) from film_actor group by actor_id order by count(film_id) desc limit 1)as sub1);


-- Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

select title from rental as r 
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id 
where customer_id in (
	Select customer_id from(
		select customer_id, sum(amount) from payment group by customer_id order by sum(amount) desc limit 1)as sub1);


-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

select customer_id, sum(amount) from payment  group by customer_id having sum(amount) > (
	Select avg(total_amount) from (
		select customer_id, sum(amount) as total_amount from payment group by customer_id order by sum(amount) desc) as sub1);