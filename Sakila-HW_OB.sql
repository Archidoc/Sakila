# 1a. Display the first and last names of all actors from the table actor.
USE Sakila;
SELECT* FROM sakila.actor;
SELECT first_name, last_name FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
USE Sakila;
UPDATE actor SET first_name = UPPER(first_name);
UPDATE actor SET last_name = UPPER(last_name);
SELECT CONCAT(first_name," ",last_name) AS 'actor name' FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
USE Sakila;
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "JOE";

#2b. Find all actors whose last name contain the letters GEN:
USE Sakila;
SELECT last_name FROM actor WHERE last_name LIKE "%GEN%";

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
USE Sakila;
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
USE Sakila;
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
USE Sakila;
ALTER TABLE actor ADD COLUMN middle_name VARCHAR (50) AFTER first_name;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor MODIFY middle_name BLOB;

#3c. Now delete the middle_name column.
ALTER TABLE actor DROP COLUMN middle_name;

#4a. List the last names of actors, as well as how many actors have that last name
USE Sakila;
SELECT last_name, COUNT(last_name) AS 'number of last name' FROM actor GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
USE Sakila;
SELECT last_name, COUNT(last_name) AS 'number of last name' FROM actor GROUP BY last_name 
HAVING COUNT(last_name) >=2;

#4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. 
# Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
USE Sakila;
SELECT first_name, last_name FROM actor 
ORDER BY last_name, first_name;

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
#Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
#BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = 'GROUCHO'
WHERE last_name = 'WILLIAMS'
AND first_name = 'HARPO';

UPDATE actor
SET first_name = 'MUCHO GROUCHO'
WHERE last_name = 'WILLIAMS'
AND first_name != 'GROUCHO';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address FROM staff s
JOIN address a
ON s.address_id = a.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, sum(p.amount) FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id
WHERE year(p.payment_date)=2005 AND month(p.payment_date)=08
GROUP BY s.staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
USE Sakila;
SELECT title, COUNT(actor_id) 
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY f.title;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
USE Sakila;
SELECT title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i
ON f.film_id=i.film_id
WHERE title = "Hunchback Impossible";
# 6 copies exist

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
USE Sakila;
SELECT last_name, first_name, SUM(amount) FROM payment p
INNER JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
USE Sakila;
SELECT title FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id in
	(SELECT language_id FROM language WHERE name = 'English');

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
USE Sakila;
SELECT last_name, first_name FROM actor WHERE actor_id in
	(SELECT actor_id FROM film_actor WHERE film_id in
		(SELECT film_id FROM film WHERE title = 'Alone Trip'));
        
#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
# Use joins to retrieve this information.
USE Sakila;
SELECT country, last_name, first_name, email FROM country co
LEFT JOIN customer c
ON co.country_id = c.customer_id WHERE country ='Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
# Identify all movies categorized as famiy films.
USE Sakila;
SELECT title, category FROM film_list WHERE category = 'Family';

#7e. Display the most frequently rented movies in descending order.
USE Sakila;
SELECT i.film_id, f.title, COUNT(r.inventory_id) FROM inventory i
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN film_text f
ON i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id)DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
USE Sakila;
SELECT store.store_id, SUM(amount) FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment p
ON p.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);

#7g. Write a query to display for each store its store ID, city, and country.
USE Sakila;
SELECT s.store_id, city, country FROM store s
INNER JOIN customer c
ON s.store_id = c.store_id
INNER JOIN staff sf
ON s.store_id = sf.store_id
INNER JOIN address a
ON c.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country cy
ON ci.country_id = cy.country_id;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
USE Sakila;
SELECT c.name, sum(p.amount)
FROM category c
JOIN film_category fc
USING(category_id)
JOIN inventory i
USING(film_id)
JOIN rental r 
USING(inventory_id)
JOIN payment p
USING(rental_id)
GROUP BY c.category_id
ORDER BY sum(p.amount) DESC
LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
USE Sakila;
CREATE VIEW top_five AS
SELECT name, sum(p.amount)
FROM category c
INNER JOIN film_category fc
INNER JOIN inventory i
ON i.film_id=fc.film_id
INNER JOIN rental r
ON r.inventory_id= i.inventory_id
INNER JOIN payment p
GROUP BY name
LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT*FROM top_five;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five;