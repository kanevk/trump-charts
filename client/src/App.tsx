import "./App.scss";
import React from "react";
import { ResponsiveContainer, PieChart, Pie, Cell, Legend, Tooltip } from "recharts";
import { DocumentNode, gql, useQuery } from "@apollo/client";

const QUERY: DocumentNode = gql`
  query getOccurrences {
    tweetsAnalytics {
      countriesOccurrences {
        name
        count
      }

      childrenOccurrences {
        name
        count
      }
    }
  }
`;

const ColumnChart = ({
  title,
  data,
}: {
  title: string;
  data: readonly object[];
}) => {
  const colors: string[] = ["#ffe200", "#ff7105", "brown", "blue", "gray", "red"];
  debugger
  return (
    <div className="column">
      <ResponsiveContainer height={250}>
        <PieChart>
          <Pie
            data={data}
            dataKey="count"
            nameKey="name"
            cx="50%"
            cy="50%"
            innerRadius={60}
            outerRadius={80}
            label={(entry) => `${entry.name}: ${entry.count}`}
          >
            {data.map((_entry, index) => (
              <Cell key={`cell-${index}`} fill={colors[index]} />
            ))}
          </Pie>
          <Tooltip />
        </PieChart>
      </ResponsiveContainer>
      <span className="title">{title}</span>
    </div>
  );
};

const App = () => {
  const { data, loading, error } = useQuery(QUERY);

  if (loading) return <div></div>;
  if (error) throw error;

  const contriesOccurrencesData = data.tweetsAnalytics.countriesOccurrences
  const childrenOccurrencesData = data.tweetsAnalytics.childrenOccurrences

  return (
    <div className="App">
      <div className="main">
        <header>
          <img src="favicon.ico" alt="Thrub's face"></img>
          <h2>Thrumb's charts</h2>
        </header>
        <div className="columns">
          <ColumnChart title="China vs Russia" data={contriesOccurrencesData} />
          <ColumnChart title="Favourite child" data={childrenOccurrencesData} />
        </div>
      </div>
    </div>
  );
};

export default App;
