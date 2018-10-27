-- Display first and last names of all actors from table actor 

use sakila;

select first_name, last_name from actor;

-- Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name

use sakila;

select concat(first_name,' ', last_name) as Actor_Name
from Actor; 

-- You need to find the ID number, first name, and last name of an actor, of whom you only know the first name, "Joe". What is one query would you use to obtain this information?

use sakila;

select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- Find all actors whose last name contain the letters GEN

use sakila; 

select last_name
from actor
where last_name like '%GEN%';  

-- Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, inthat order

use sakila;

select last_name, first_name
from actor
where last_name like '%LI%'

order by last_name, first_name;

-- using IN, display the country_id an dcountry columns of the following vountries: Afganistan, Bangladesh, and China

use sakila;

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description
-- and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and the VARCHAR are significant)

use sakila;

ALTER TABLE actor
add column description VARCHAR(50);

select * from actor;

-- will modify to BLOB type

use sakila;

ALTER TABLE actor

MODIFY description BLOB;

select * from actor;

-- Very quickly you realize that entering descriptions for each actors is too much effort. Delete the decription column.alter

use sakila;

ALTER TABLE actor
drop column description;

select * from actor;

-- List the names of actors, as well as how many actors have that last name

use sakila;

select last_name, count(last_name) as "Count of Last Names"
from actor
group by last_name;

-- list last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

use sakila;

select last_name, count(*) as "Count of Last Names" 
from actor group by last_name HAVING count(*) >=2;


-- the actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record

use sakila;
 
update actor
set first_name = "Harpo"
where first_name = "Groucho" and last_name = "Williams";

select actor_id, first_name, last_name
from actor
where first_name = 'Harpo';

-- turns out the correct name was GROUCHO. In a single query, if the first name is HARPO, change it GROUCHO

use sakila;
 
update actor
set first_name = "GROUCHO"
where first_name = "Harpo" and last_name = "Williams";

select actor_id, first_name, last_name
from actor
where first_name = 'GROUCHO';

-- you cannot locate the schema of the address table. which query would you use to re-create it?

show create table sakila.address;

-- use join to display the first and last name, as well as address, of each staff member. Use staff and address

SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id=address.address_id;


-- use join to display the total amount rung up by each staff member in august 2005. Use tables staff and payment

SELECT staff.first_name, staff.last_name, SUM(amount)
FROM staff
INNER JOIN payment ON
staff.staff_id=payment.staff_id
group by payment.staff_id;

-- list each film and the number of actors who are listed for that film. Use tables film actor and film. Use inner join

SELECT film.title, count(actor_id) as "Number of actors in the movie"
FROM film_actor
INNER JOIN film ON
film.film_id=film_actor.film_id
group by title;

-- how many copies of the film HunchBack Impossible exist in the inventory system

SELECT film.title, count(title) 
FROM film
INNER JOIN inventory ON
film.film_id=inventory.film_id
where title = "Hunchback Impossible";


-- using the tables payment and customer and the JOIN command, list the total paid by each customer. list alphabetically.alter

SELECT customer.first_name, customer.last_name, sum(amount)
FROM payment
INNER JOIN customer ON
customer.customer_id = payment.customer_id
group by payment.customer_id
order by last_name ASC;

-- the music of Queen and Kris Kristofferson.... use sub queries to display the titles of movies starting with the letters K and Q whose language is English

use sakila;

select title from film
where language_id in
	(select language_id
    from language
    where name = "English")
    
and (title like "Q%") or (title like "K%");


-- use subqueries to display all actors who appear in the film alon trip


USE Sakila;

SELECT last_name, first_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));


-- you want to run an email marketing campaing in CAnada... use join to retreive this information

 
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
INNER JOIN address ON
customer.address_id = address.address_id
inner join city ON
city.city_id = address.address_id
inner join country on
country.country_id = city.country_id
where country = 'Canada';

select * from country;

select * from customer;

-- sales have been lagging among young families. identify all movies categorized as family films

USE Sakila;

SELECT title, category
FROM film_list
WHERE category = 'Family';

--  Display the most frequently rented movies in descending order.


USE Sakila;

SELECT inventory.film_id, film_text.title, COUNT(rental.inventory_id)
FROM inventory 
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN film_text  
ON inventory.film_id = film_text.film_id
GROUP BY film_text.title
order by COUNT(rental.inventory_id) DESC;


-- Write a query to display how much business, in dollars, each store brought in

SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment  
ON payment.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);

-- Write a query to display for each store its store ID, city, and country.

USE Sakila;

SELECT store.store_id, city, country
FROM store 
INNER JOIN customer 
ON store.store_id = customer.store_id
INNER JOIN staff 
ON store.store_id = staff.store_id
INNER JOIN address 
ON customer.address_id = address.address_id
INNER JOIN city 
ON address.city_id = city.city_id
INNER JOIN country 
ON city.country_id = country.country_id;

-- List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

-- In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
  	
--  How would you display the view that you created in 8a?

SELECT * FROM genre_revenue;

--  You find that you no longer need the view `top_five_genres`. 
--  Write a query to delete it.

DROP VIEW genre_revenue;