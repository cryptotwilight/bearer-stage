import React from "react";
import ChartistGraph from "react-chartist";
// react-bootstrap components
import {
  Badge,
  Button,
  Card,
  Navbar,
  Nav,
  Table,
  Container,
  Row,
  Col,
  Form,
  OverlayTrigger,
  Tooltip,
} from "react-bootstrap";

function Dashboard() {
  return (
    <>
      <Container fluid>
        <Row>
          <Col lg="3" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning">
                      <i className="nc-icon nc-money-coins text-warning"></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category">Total Allocated Inventory</p>
                      <Card.Title as="h4">USDC 1,500,000.00</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                  <i className="fas fa-redo mr-1"></i>
                 Refresh
                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col lg="3" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning">
                      <i className="nc-icon nc-chart-bar-32 text-success"></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category">Average Repayment Interest(p/m)</p>
                      <Card.Title as="h4">10%</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                  <i className="far fa-calendar-alt mr-1"></i>
                  Last day
                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col lg="3" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning">
                      <i className="nc-icon nc-tag-content text-danger"></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category">Liquidation Threshold</p>
                      <Card.Title as="h4">45%</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                  <i className="far fa-clock-o mr-1"></i>
                  In the last hour
                </div>
              </Card.Footer>
            </Card>
          </Col>
          <Col lg="3" sm="6">
            <Card className="card-stats">
              <Card.Body>
                <Row>
                  <Col xs="5">
                    <div className="icon-big text-center icon-warning">
                      <i className="nc-icon nc-umbrella-13 text-primary"></i>
                    </div>
                  </Col>
                  <Col xs="7">
                    <div className="numbers">
                      <p className="card-category">Fulfilment Score</p>
                      <Card.Title as="h4">95%</Card.Title>
                    </div>
                  </Col>
                </Row>
              </Card.Body>
              <Card.Footer>
                <hr></hr>
                <div className="stats">
                  <i className="fas fa-redo mr-1"></i>
                  Redeem
                </div>
              </Card.Footer>
            </Card>
          </Col>
        </Row>
        <Row>
          <Col md="8">
          <Card className="strpied-tabled-with-hover">
              <Card.Header>
                <Card.Title as="h4">Hotels</Card.Title>
                <p className="card-category">
                 These are the hotels that are releasing inventory
                </p>
              </Card.Header>
              <Card.Body className="table-full-width table-responsive px-0">
                <Table className="table-hover table-striped">
                  <thead>
                    <tr>
                      <th className="border-0">ID</th>
                      <th className="border-0">Hotel</th>
                      <th className="border-0">Remaining Availability (12 months) </th>
                      <th className="border-0">Discount</th>
                      <th className="border-0">Interest Repayment (p/m) </th>
                      <th className="border-0">Min Allotment (USDC) </th> 
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>1</td>
                      <td>Dakota Rice Hotel</td>
                      <td>60%</td>
                      <td>15%</td>
                      <td>5%</td>
                      <td>$989,098.00</td>
                    </tr>
                    <tr>
                      <td>2</td>
                      <td>Minerva Hooper Hotel</td>
                      <td>60%</td>
                      <td>15%</td>
                      <td>5%</td>
                      <td>$989,098.00</td>
                    </tr>
                    <tr>
                      <td>3</td>
                      <td>Sage Rodriguez Hotel</td>
                      <td>60%</td>
                      <td>15%</td>
                      <td>5%</td>
                      <td>$989,098.00</td>                
                    </tr>
                    <tr>
                      <td>4</td>
                      <td>Philip Chaney Residence</td>
                      <td>60%</td>
                      <td>15%</td>
                      <td>5%</td>
                      <td>$989,098.00</td>
                    </tr>
                    <tr>
                      <td>5</td>
                      <td>Doris Greene Palace</td>
                      <td>60%</td>
                      <td>15%</td>
                      <td>5%</td>
                      <td>$989,098.00</td>
                    </tr>
                    <tr>
                      <td>6</td>
                      <td>Mason Porter Hotel</td>
                      <td>60%</td>
                      <td>15%</td>
                      <td>5%</td>
                      <td>$989,098.00</td>
                    </tr>
                  </tbody>
                </Table>
              </Card.Body>
            </Card>
          </Col>
          <Col md="4">
          <Card>
              <Card.Header>
                <Card.Title as="h4">Buy Inventory</Card.Title>
              </Card.Header>
              <Card.Body>
                <Form>
                  <Row>
                    <Col className="pr-1" md="4">
                      <Form.Group>
                        <label>Hotel Pool </label>
                        <Form.Control
                          defaultValue="Hotel 1"
                          disabled                      
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                    <Col className="px-1" md="4">
                      <Form.Group>
                        <label>Current Cap. (USDC) </label>
                        <Form.Control
                          defaultValue="456,356"                          
                          disabled
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                    <Col className="pl-1" md="4">
                      <Form.Group>
                        <label >
                          Max Capacity (USDC)
                        </label>
                        <Form.Control
                          defaultValue="789,890"
                          disabled
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                  </Row>
                  <Row>
                    <Col className="pr-1" md="4">
                      <Form.Group>
                        <label>Emissions (%)</label>
                        <Form.Control
                          defaultValue="8.5"
                          disabled                       
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                    <Col className="pl-1" md="4">
                      <Form.Group>
                        <label>Min Term (months)</label>
                        <Form.Control
                          defaultValue="12"
                          disabled
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                    <Col className="pl-1" md="4">
                      <Form.Group>
                        <label>Ave. Utlisation (%)</label>
                        <Form.Control
                          defaultValue="60%"
                          disabled
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                  </Row>
                  <Row>
                    <Col md="12">
                      <Form.Group>
                        <label>Investment (USDC)</label>
                        <Form.Control
                          defaultValue=""
                          placeholder="Amount to add to pool"
                          type="text"
                        ></Form.Control>
                      </Form.Group>
                    </Col>
                  </Row>

                  <Button
                    className="btn-fill pull-right"
                    type="submit"
                    variant="info"
                  >
                    Commit Funds
                  </Button>
                  <div className="clearfix"></div>
                </Form>
              </Card.Body>
            </Card>
          </Col>
        </Row>
        <Row>
        <Col md="12">
            <Card className="card-plain table-plain-bg">
              <Card.Header>
                <Card.Title as="h4">Your Coupons</Card.Title>
                <p className="card-category">
                  Coupons with investment amounts
                </p>
              </Card.Header>
              <Card.Body className="table-full-width table-responsive px-0">
                <Form>
                <Table className="table-hover">
                  <thead>
                    <tr>
                      <th className="border-0">ID</th>
                      <th className="border-0">Hotel</th>
                      <th className="border-0">Investment (USDC) </th>
                      <th className="border-0">Emission (%)</th>
                      <th className="border-0">Remaining Term (months)</th>
                      <th className="border-0">Residual (%)</th>
                      <th  className="border-0">Redeem</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>1</td>
                      <td>Dakota Rice Hotel</td>
                      <td>$36,738</td>
                      <td>6</td>
                      <td>9</td>
                      <td>25</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>2</td>
                      <td>Minerva Hooper Hotel</td>
                      <td>$23,789</td>
                      <td>7</td>
                      <td>10</td>
                      <td>20</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>3</td>
                      <td>Sage Rodriguez Hotel</td>
                      <td>$56,142</td>
                      <td>7</td>
                      <td>10</td>
                      <td>20</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>4</td>
                      <td>Philip Chaney Hotel</td>
                      <td>$38,735</td>
                      <td>7</td>
                      <td>10</td>
                      <td>20</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>5</td>
                      <td>Doris Greene Hotel</td>
                      <td>$63,542</td>
                      <td>7</td>
                      <td>10</td>
                      <td>20</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                    <tr>
                      <td>6</td>
                      <td>Mason Porter Hotel</td>
                      <td>$78,615</td>
                      <td>7</td>
                      <td>10</td>
                      <td>20</td>
                      <td>     
                        <Form.Group>
                        <Form.Control
                          defaultValue="unchecked"
                          type="checkbox"
                        ></Form.Control>
                      </Form.Group>
                      </td>
                    </tr>
                  </tbody>
                </Table>
                </Form> 
                <Button
                    className="btn-fill pull-right"
                    type="submit"
                    variant="info"
                  >
                   Redeem Coupons
                  </Button>
                  <div className="clearfix"></div>
              </Card.Body>
            </Card>
          </Col>
        </Row>
      </Container>
    </>
  );
}

export default Dashboard;
