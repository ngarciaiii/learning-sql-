/*
| name | continent | area |	population | gdp |
| Afghanistan |	Asia | 652230 | 25500100 | 20343000000 |
| Albania |	Europe | 28748 | 2831741 | 12960000000 |
| Algeria |	Africa | 2381741 | 37100000 | 188681000000 |
| Andorra |	Europe | 468 | 78115 | 3712000000 |
| Angola |	Africa | 1246700 | 20609294 | 100990000000 |
| ... |


1) List each country name where the population is larger than that of 'Russia'.
world (name, continent, area, population, gdp)
*/

SELECT name, continent, area, population, gdp FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Russia')

/*
2) Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
*/

SELECT name FROM world
WHERE continent = 'Europe'
  AND gdp/population > (SELECT gdp/population FROM world WHERE name = 'United Kingdom')

/*
3) List the name and continent of countries in the continents containing either Argentina or Australia.
Order by name of the country.
*/

SELECT name, continent FROM world
WHERE continent IN (SELECT name FROM world WHERE name IN ('Argentina', 'Australia'))
ORDER BY name

/*
4) Which country has a population that is more than Canada but less than Poland?
Show the name and the population.
*/

SELECT name, population FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Canada')
  AND population < (SELECT population FROM world WHERE name = 'Poland')

/*
5) Germany (population 80 million) has the largest population of the countries in Europe.
Austria (population 8.5 million) has 11% of the population of Germany.

Show the name and the population of each country in Europe.
Show the population as a percentage of the population of Germany.

Decimal places
You can use the function ROUND to remove the decimal places.
Percent symbol %
You can use the function CONCAT to add the percentage symbol.
*/

SELECT name,
  CONCAT(ROUND((population*100)/(SELECT population FROM world WHERE name = 'Germany') 0) %)
FROM world
WHERE continent = 'Europe'

/*
To get a well rounded view of the important features of SQL you should move on to the next tutorial concerning aggregates.

To gain an absurdly detailed view of one insignificant feature of the language, read on.

We can use the word ALL to allow >= or > or < or <=to act over a list. For example,
you can find the largest country in the world, by population with this query:

You need the condition population>0 in the sub-query as some countries have null for population.
*/

SELECT name FROM world
WHERE population >= ALL(SELECT population FROM world WHERE population>0)

/*
6) Which countries have a GDP greater than every country in Europe?
[Give the name only.] (Some countries may have NULL gdp values)
*/

SELECT name FROM world
WHERE gdp > ALL (SELECT gdp FROM world WHERE continent = 'Europe' AND gdp > 0)

/*
We can refer to values in the outer SELECT within the inner SELECT.
We can name the tables so that we can tell the difference between the inner and outer versions.

7) Find the largest country (by area) in each continent, show the continent, the name and the area:
*/

SELECT continent, name, area FROM world x
WHERE area >= ALL (SELECT area FROM world y WHERE y.continent=x.continent
  AND area > 0)

/*
8) List each continent and the name of the country that comes first alphabetically.
*/

SELECT contient, name FROM world x
WHERE name <= ALL(SELECT name FROM world y WHERE y.continent = x.continent)

/*
Difficult Questions That Utilize Techniques Not Covered In Prior Sections

9) Find the continents where all countries have a population <= 25000000.
Then find the names of the countries associated with these continents.
Show name, continent and population.
*/

SELECT name, continent, population FROM world x
WHERE 25000000 > ALL (SELECT population FROM world y
  WHERE x.continent = y.continent AND y.population > 0)

/*
10) Some countries have populations more than three times that of any of their neighbours
(in the same continent). Give the countries and continents.
*/

SELECT name, continent FROM world x
WHERE population > ALL(SELECT population*3 FROM world y WHERE x.continent = y.continent AND population > 0 AND y.name != x.name)


-- QUIZ

/*
1) Select the code that shows the name, region and population of the smallest country in each region
*/

 SELECT region, name, population FROM bbc x
 WHERE population <= ALL (SELECT population FROM bbc y WHERE y.region=x.region AND population>0)

/*
2) Select the code that shows the countries belonging to regions with all populations over 50000
*/

 SELECT name,region,population FROM bbc x
 WHERE 50000 < ALL (SELECT population FROM bbc y WHERE x.region=y.region AND y.population>0)

/*
3) Select the code that shows the countries with a less than a third of the population of the countries around it
*/

SELECT name, region FROM bbc x
WHERE population < ALL (SELECT population/3 FROM bbc y WHERE y.region = x.region AND y.name != x.name)

/*
4) Select the result that would be obtained from the following code:

| France |
| Germany |
| Russia |
| Turkey |

*/

/*
5) Select the code that would show the countries with a greater GDP than any country in Africa
(some countries may have NULL gdp values).
*/

SELECT name FROM bbc
WHERE gdp > (SELECT MAX(gdp) FROM bbc WHERE region = 'Africa')

/*
6) Select the code that shows the countries with population smaller than Russia but bigger than Denmark
*/

SELECT name FROM bbc
WHERE population < (SELECT population FROM bbc WHERE name='Russia')
   AND population > (SELECT population FROM bbc WHERE name='Denmark')

/*
7) >Select the result that would be obtained from the following code:

| Bangladesh |
| India |
| Pakistan |
*/
