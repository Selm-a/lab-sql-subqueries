use sakila ;

# 1. How many copies of the film Hunchback Impossible exist in the system?

select * from inventory;
select * from film where title = "Hunchback Impossible";

select count(inventory_id) as number_copies
from inventory i 
join film f on i.film_id = f.film_id 
where f.title = "Hunchback Impossible";

select film_id from film where title = "Hunchback Impossible";

select count(inventory_id) as number_copies from inventory where film_id = (select film_id from film where title = "Hunchback Impossible");

#2. List all films whose length is longer than the average of all the films.

select * from film ;

select avg(length) from film ;

select * from film where length > (select avg(length) from film );

#3. Use subqueries to display all actors who appear in the film Alone Trip.
select * from film; # nom du film 
select * from actor ; # nom acteur 
select * from film_actor;

select film_id from film where title = "Alone Trip";

select actor_id from film_actor where film_id = (select film_id from film where title = "Alone Trip");

select first_name, last_name, actor_id from actor where actor_id in (select actor_id from film_actor where film_id = (select film_id from film where title = "Alone Trip"));

#4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select * from category;

select category_id from category where name = "Family";

select film_id from film_category where category_id = (select category_id from category where name = "Family");

select title from film where film_id in (select film_id from film_category where category_id = (select category_id from category where name = "Family"));

#3. Get name and email from customers from Canada using subqueries. Do the same with joins. 
#Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select * from customer ;
select * from address ;
select * from city ;
select * from country ;

select country_id from country where country = "Canada";

select city_id from city where country_id = (select country_id from country where country = "Canada");

select address_id from address where city_id in (select city_id from city where country_id = (select country_id from country where country = "Canada"));

select first_name, last_name, email from customer where address_id in 
(select address_id from address where city_id in (select city_id from city where country_id = (select country_id from country where country = "Canada")));

select c.first_name, c.last_name, c.email 
from customer c
join address a on a.address_id = c.address_id
join city ci on ci.city_id = a.city_id
join country co on co.country_id = ci.country_id 
where co.country = "Canada";

#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select * from actor ;
select * from film_actor ;
select * from film ;

select actor_id, count(film_id) as number_of_film
from film_actor 
group by actor_id 
order by number_of_film desc limit 1;

select actor_id from actor where actor_id = 107;

select film_id from film_actor where actor_id = (select actor_id from actor where actor_id = 107);

select title from film where film_id in (select film_id from film_actor where actor_id = (select actor_id from actor where actor_id = 107));



select actor_id from (select actor_id, count(film_id) as number_of_film
from film_actor 
group by actor_id 
order by number_of_film desc limit 1) as most_prolific;

select f.title
from film f
join film_actor fa on f.film_id = fa.film_id 
where actor_id = (select actor_id from (select actor_id, count(film_id) as number_of_film
from film_actor 
group by actor_id 
order by number_of_film desc limit 1) as most_prolific);


#7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select * from customer ;
select * from payment;

select sum(amount) as total_amount, customer_id 
from payment 
group by customer_id 
order by total_amount desc limit 1; 

select customer_id from (select sum(amount) as total_amount, customer_id 
from payment 
group by customer_id 
order by total_amount desc limit 1) as most_profitable; 

select f.title
from film f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id 
where r.customer_id = (select customer_id from (select sum(amount) as total_amount, customer_id 
from payment 
group by customer_id 
order by total_amount desc limit 1) as most_profitable); 

#Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select * from payment; 

select sum(amount) as total_amount, customer_id
from payment 
group by customer_id;

select avg(total_amount) from (select sum(amount) as total_amount, customer_id
from payment 
group by customer_id) as total_amount;


select sum(amount) as total_amount, customer_id
from payment 
group by customer_id
having total_amount > (select avg(total_amount) from (select sum(amount) as total_amount, customer_id
from payment 
group by customer_id) as total_amount);




