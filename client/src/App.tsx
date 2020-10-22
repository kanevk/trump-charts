import "./App.scss";
import React from "react";
import {
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  Tooltip,
  AreaChart,
  XAxis,
  YAxis,
  CartesianGrid,
  Area,
} from "recharts";
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

      democracyByYear {
        name
        count
        year
      }
    }
  }
`;

const CellPieChart = ({
  title,
  data,
}: {
  title: string;
  data: readonly object[];
}) => {
  const colors: string[] = [
    "#ffe200",
    "#ff7105",
    "#8884d8",
    "#FFC4AA",
    "#FB8D76",
    "#BE5845",
  ];

  return (
    <div className="cell">
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
  const { data, error } = useQuery(QUERY);

  if (error) throw error;

  const { countriesOccurrences, childrenOccurrences, democracyByYear } =
    data?.tweetsAnalytics || {};

  return (
    <div className="App">
      <div className="main">
        <header>
          <img src="favicon.ico" alt="Thrub's face"></img>
          <h2>Thrumb's charts</h2>
        </header>
        <div className="cells">
          <CellPieChart
            title="China vs Russia"
            data={countriesOccurrences || []}
          />
          <CellPieChart
            title="Favourite child"
            data={childrenOccurrences || []}
          />
          <RowAreaChart title="Democracy mentions during time" data={democracyByYear || []} />
        </div>
      </div>
    </div>
  );
};

const RowAreaChart = ({
  title,
  data,
}: {
  title: string;
  data: readonly object[];
}) => {
  return (
    <div className="row">
      <ResponsiveContainer height={250}>
        <AreaChart
          width={730}
          height={250}
          data={data || []}
          margin={{ top: 10, right: 30, left: 0, bottom: 0 }}
        >
          <defs>
            <linearGradient id="democracyGradient" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#8884d8" stopOpacity={0.8} />
              <stop offset="95%" stopColor="#8884d8" stopOpacity={0} />
            </linearGradient>
          </defs>
          <XAxis dataKey="year" />
          <YAxis />
          <CartesianGrid strokeDasharray="3 3" />
          <Tooltip />
          <Area
            type="monotone"
            dataKey="count"
            stroke="#8884d8"
            fillOpacity={1}
            fill="url(#democracyGradient)"
          />
        </AreaChart>
      </ResponsiveContainer>
      <span className="title">{title}</span>
    </div>
  );
};

export default App;
