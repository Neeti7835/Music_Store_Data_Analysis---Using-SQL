                                            "(EASY)"
												
Q1. Who is the most senior employee based on job title?

Select * from employee
Order by levels desc
limit 1

Q2. Which country have the most invocies?

select Count(*) as c , billing_country
from invoice
group by billing_country
order by c desc

Q3. What are the top 3 values of total invoice?

Select total from invoice
order by total desc
limit 3

                                            "(MODERATE)"
												
Q4. Which city has the best customers? We would like to throw a promotional music festival in the city 
we made the most money. Write a query that returns one city has the highest sum of invoices total. Return
both the city name & sum of all invoice totals.

select sum(total) as invoic_total, billing_city
from invoice	
group by billing_city
order by invoic_total desc

Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money.

select customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) as total
from customer
join invoice ON customer.customer_id = invoice.invoice_id
GROUP BY customer.customer_id
Order By total DESC
limit 1

Q6. Write query to return the email, first name,last name & Genre of all Rock Music Listeners. Return your list
orderes alphabetically by email starting with A.

select Distinct email, first_name, last_name
from customer
JOIN invoice ON  customer.customer_id = invoice.invoice_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
Where track_id IN(
      	           Select track_id From track
	               Join genre On track.genre_id = genre.genre_id
	               Where genre.name like 'Rock'
)
ORDEr by email;	

Q6. Let's invite the artists who have written the most rock music in our dataset. Write a query that returns 
	the Artist name and total track count of the top 10 rocks bands.
	
select artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
from track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id 
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
Limit 10;

Q6. Return all the track names that hava a song length longer than the average song length. Return the Name 
	and Milliseconds for each track. Order by the song length with the longest songs listed first.

SELECT name, milliseconds 
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
    from track)
ORDER BY milliseconds DESC;

                                            '(ADVANCE)'
	
Q7. Find how much amount spent by each customer on artists? Write a query to return custom name, 
	artist name and total spent.

WITH best_selling_artist AS(
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name,
	SUM (invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
	
    SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
    SUM(il.unit_price*il.quantity) AS amount_spent
    FROM invoice i
    JOIN customer c ON c.customer_id =i.customer_id
    JOIN invoice_line il ON il.invoice_id = i.invoice_id
    JOIN track t ON t.track_id = il.track_id	
    JOIN album alb ON alb.album_id = t.album_id
    JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
   GROUP BY 1, 2, 3, 4 
   ORDER BY 5 DESC;

Q8. We wamt to find out the most popular music Genre for each country. We determine the most 
popuklar genre as the genre with the highest amount of purchases. Write a query that returns each country 
along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.

WITH popular_genre AS
	( 
	   SELect COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
       ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
	   FROM invoice_line
	   JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	   JOIN customer ON customer.customer_id = invoice.customer_id
	   JOIN track ON track.track_id = invoice_line.track_id
	   JOIN genre ON genre.genre_id = track.genre_id
	   GROUP BY 2,3,4
	   ORDER BY 2 ASC, 1 DESC
	)
  SELECT * FROM popular_genre WHERE RowNo <= 1
	
Q9. Write a query that determines the customer that has spent the most on music for each country. Write a query 
	that returns the country along with the top customer and how much they spent. For countrues where the top 
	amount spent is shared, provide all customers who spent this amount.
	
  WITH customer_with_country AS(
           SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending,
	       ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNO
	       FROM invoice
	       JOIN customer ON customer.customer_id = invoice.customer_id
	       GROUP BY 1,2,3,4
	       ORDER BY 4 ASC, 5 DESC)
	SELECT * FROM customer_with_country WHERE RowNo <= 1
	
	
	
	

	
	

	

	

	

